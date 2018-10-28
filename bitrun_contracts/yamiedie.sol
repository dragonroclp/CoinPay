pragma solidity ^0.4.0;
import "./coinware.sol";
import "./interfaces.sol";
import "./safemath.sol";

contract yamiedie is CoinWare{
    using SafeMath for uint;
    
    event Exchange(address _from,address _to,string _fromCoinName,string _toCoinName,uint value);
    event Award(string _coinName,address _to,uint _value);
    
    string [] private _coinNames=["BitMartToken","Nerves","CryptoKitties"];
    Token [] private _contracts;
    mapping(string=>Token)nameToContract;
    mapping(string => uint)_coinBase;
    
    // uint paynum=0;
    // uint 
    
    BMCInterface BitMartContract = BMCInterface(0xB8c77482e45F1F44dE1745F52C74426C631bDD52);
    NERInterface NervesContract = NERInterface(0xEE5dFB5Ddd54eA2fB93b796a8A1b83C3fe38E0e6);
    KittyInterface CryptoKittiesContract = KittyInterface(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);
    
    function yamiedie()payable{
        _contracts.push(BitMartContract);
        _contracts.push(NervesContract);
        _contracts.push(CryptoKittiesContract);
        for(uint i=0;i<3;i++){
            nameToContract[_coinNames[i]] = _contracts[i];
        }
        
    }
    
    function setNewContract(string _coinName,address _contractAddr)onlyOwner{
        
    }

    
    function _isEqual(string a,string b)private returns(bool){
        if (bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(bytes(a)) == keccak256(bytes(b));
        }
    }
    
    function receiveCoin(string _fromName, uint _value,bool tag)payable returns(address sender, uint amount, bool success){
        require(tag);
        if(_isEqual(_fromName,"ether")){
            require(msg.value>=_value);
        }else{
        _coinBase[_fromName] = _coinBase[_fromName].add(_value);
        }
        return (msg.sender,_value,tag);
        
    }
    
    function paycoin(string _toCoinName,address _to,uint _value) private{
        if(_isEqual(_toCoinName,"ether")){
            require(this.balance>=_value);
            _to.transfer(_value);
        }else{
            if(_coinBase[_toCoinName]>_value){
                nameToContract[_toCoinName].transfer(_to,_value);
                _coinBase[_toCoinName] = _coinBase[_toCoinName].sub(_value);
            }else{
            //连接交易所共享币池
            //在各交易所挂单买进fromcoinname
            nameToContract[_toCoinName].transfer(_to,_value);
            }
        }
    }
    
    //跨币支付
    function Pay(address _to,uint _value,string _fromCoinName,string _toCoinName,uint exchangeRate,bool ifReceived)payable{
        receiveCoin(_fromCoinName,_value,ifReceived);
        _value = _value.mul(exchangeRate); //乘以兑换比率
        paycoin(_toCoinName,_to,_value);
        emit Exchange(msg.sender,_to,_fromCoinName,_toCoinName,_value);
    }
    
    function _createRand()view private returns(uint){
        uint randNum = uint(keccak256(now, msg.sender))%100;
        return randNum;
    }
    
    
    function gamble(uint _value,string _fromCoinName,string _toCoinName, bool _ifReceived)payable returns(uint){
        uint randNum = _createRand();
        uint transferNum;
        //require(_coinBase[_toCoinName]>0);
        receiveCoin(_fromCoinName,_value,_ifReceived);
        if(randNum>75) {transferNum=1;}
        else if(randNum>50){transferNum=2;}
        else if(randNum>25){transferNum=3;}
        else {transferNum=4;}
        paycoin(_toCoinName,msg.sender,transferNum);
        emit Award(_toCoinName,msg.sender,transferNum);
        return _coinBase[_toCoinName];
    }
    
    
}
