pragma solidity ^0.4.0;
import "./safemath.sol";
import "./ownable.sol";

contract CoinWare is Ownable{
    using SafeMath for uint;
    
    event NewAccount(address _addr);
    event balanceUp(address _addr,string _coinName, uint _value);
    event balanceDown(address _addr,string _coinName,uint _value);
    
    mapping(string => uint)_coinBase;
    struct Account{
        address contributorAddr;
        mapping(string =>uint) balance;
    }
    
    
    mapping(address=>bool) tag;
    mapping(address=>Account)ownerAccount;
    

    modifier accountCreated(address _addr){
        require(tag[_addr]==true);
        _;
    }
    
    modifier onlyAccountOwner(address _addr){
        require(msg.sender==_addr);
        _;
    }
    
    
    
    
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

    
}
