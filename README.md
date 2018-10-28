# CoinPay
支持多种数字资产即时交易和转换的去中心化闪兑协议
### 项目描述
CoinPay是一个数字货币交易和转换系统，使得用户能快速的将自己手中的某种代币转换为等价的其他代币，并提供能使用户在闪兑过程中获得额外收益的功能。CoinPay解决的主要问题是，用户不需要像在中心化交易所那样充值提现，而直接可以使用去中心化交易平台在不同代币之间进行无缝支付。
### 项目功能
CoinPay主要通过利用自有链的储备库、外接币池两种方式实现闪兑功能。它还提供gamble的特色方式供用户闪兑，允许用户有一定概率获得额外的收益。项目的流程图及主要的三个功能描述如下：
<img align=center width="440" height="440" src='https://github.com/dragonroclp/CoinPay/blob/master/flow%20chart.jpeg'/>
* 1.用自由链的储备库实现闪兑
>>用自有链在其他数字资产链上（如比特币、以太坊等）生成一个地址，用于存放用户想兑换的币种数据。当自有链的储备库拥有*足额的数字货币*、能满足用户需求时，在自有链上用智能合约实现币种之间的兑换。
* 2.采用外接币池方式实现闪兑 
>>当自有链储备库不能满足客户的换币需求时，可以借助其他交易所（中心化或去中心化），*外接币池*，利用其他交易所的数字资产来进行闪兑。
* 3.采用gamble思想实现闪兑
>>除上述两种方式外，用户还可以用gamble这种资产收益不确定的方式来进行兑换，以期获得超额收益。用户输入自己用于支付的币种和数量后，可以选择自己要兑换的币种，平台反馈给用户随机的数量。在这种方式下，用户的*期望收益率为0%。*
##### 在本组设计的去中心化闪兑交易平台上，类的实体包括用户、平台、储存库以及储备贡献者。示意图如下：
<img align=center width="600" height="300" src='https://github.com/dragonroclp/CoinPay/blob/master/class%20diagram.jpg'/>

### 代码实现（核心代码）
#### 网页客户端
- 功能1及功能2（币种直接兑换）页面

>>在这个页面中，用户需要输入自己的姓名、用于兑换的币种和数量，以及想兑换的币种，平台显示实时汇率，若用户决定进行兑换，则平台会记录用户的资产变更。
- 功能3（赌博兑换）页面

>>在这个页面中，用户需要输入自己的姓名以及用于兑换的币种和数量，平台返回用户在此次支付中得到的资产值。
```
import  Nervos from './node_modules/@nervos/chain';
    const nervos =Nervos('http://localhost:1337');
    var sendTo= 0xcB700EE03b47d5fCb389D39B6a76cBC3E1C5ac0f;
const abi=Json.parse([
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_coinName",
                    "type": "string"
                },  //只截取了一部分
const contract=new nervos.appchain.Contract(abi,contractAddress)
    var e1=document.getElementById('have1').value;
    var e2=document.getElementById('number').value;
    
    //const simpleStoreContract = new nervos.appchain.Contract(abi, contractAddress);
    function pay_action() {
contract.methods.gambling(e1,e2).call()
        contract.event.balanceUp()
            .on("data",function(event){
                let data = event.returnValue;
                console.log("success",data._coinName,data._coinValue)
            }).on('error',console.error)
nervos.listeners.listenToTransactionReceipt().then(console.log)
    }
```
#### 智能合约
##### 本组在Nervos提供的开发环境下，设计实现了5个智能合约，分别是coinware.sol、interfaces.sol、ownable.sol、safemath.sol、yamiedie.sol。
- ownable合约
>>该合约规定了当用户将自己拥有的数字资产存储在本平台在其他链的地址时，只有拥有这些资产的用户和平台拥有者可以将这些数字资产取出。
```
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }
  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }}
```
- safemath合约
>>该合约规定了安全的数字运算范围。
- coinware合约
>>该合约规定了用户存入和取出（放弃兑换时）自己拥有的数字资产的方式。
```
function _createNewCount(string _coinName,address _addr, uint _value)internal{
        ownerAccount[_addr] = Account(_addr);
        ownerAccount[_addr].balance[_coinName] = _value;
        emit NewAccount(_addr);
    }
            function sendToCoinWare(string _coinName, uint _value)public{
        if(tag[msg.sender]==false){
            
            _createNewCount(_coinName,msg.sender,_value);
            tag[msg.sender] = true;
        }else{
            ownerAccount[msg.sender].balance[_coinName] = ownerAccount[msg.sender].balance[_coinName].add(_value);
        }
        _coinBase[_coinName] = _coinBase[_coinName].add(_value);
        emit balanceUp(msg.sender,_coinName, _value);
    }
    
function withdraw(string _coinName,uint _value)payable public accountCreated(msg.sender) onlyAccountOwner(msg.sender)returns(uint){
        require(ownerAccount[msg.sender].balance[_coinName]>=_value);
        ownerAccount[msg.sender].balance[_coinName] = ownerAccount[msg.sender].balance[_coinName].sub(_value);
        _coinBase[_coinName] = _coinBase[_coinName].sub(_value);
        emit balanceDown(msg.sender,_coinName,_value);
        return _coinBase[_coinName];   
    }
```
- yamiedie合约
>>该合约定义了在该平台上跨币支付和兑换的方式。
```
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
```
- interfaces合约
>>该合约实现了与其他已有合约的连接，使得在进行兑换时，可以实现连接币池和赌博方式随机返回资产这两种兑换方式。
```
interface Token{
    function transfer(address _to,uint _value);
}
 
contract KittyInterface is Token{
    function getKitty(uint256 _id)external view returns( 
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes);
    function transfer(address _to, uint256 _tokenId);
    
} 

contract BMCInterface is Token{
    function transfer(address _to, uint256 _value) public;
    
}

contract NERInterface is Token{
    function transfer(address _to, uint256 _value) ;
}
```
