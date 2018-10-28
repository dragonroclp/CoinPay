pragma solidity ^0.4.0;


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

// contract BNBInterface is Token{
//     function transfer(address _to, uint256 _value);
//     function approve(address _spender, uint256 _value)returns (bool success);
    
// }

// contract VENInterface is Token{
//     function transfer(address _to, uint256 _amount) returns (bool success);
    
// }

contract BMCInterface is Token{
    function transfer(address _to, uint256 _value) public;
    
}


contract NERInterface is Token{
    function transfer(address _to, uint256 _value) ;
}

