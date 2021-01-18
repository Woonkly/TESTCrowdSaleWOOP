// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Pausable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/access/Roles.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/ownership/Ownable.sol";


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/crowdsale/Crowdsale.sol";


interface WOPMintable{
    function addNewMinterBurner(address me,address sc) external;

}


contract WOP is ERC20Mintable,ERC20Burnable, ERC20Detailed,ERC20Pausable,Ownable  {
    
    using Roles for Roles.Role;

    Roles.Role private _minters;
    Roles.Role private _burners;
    
    constructor(
        uint256 initialSupply,
        address[] memory minters, 
        address[] memory burners        
        ) ERC20Detailed("Woonkly Power", "WOP", 18) public {  
        _mint(msg.sender, initialSupply);

        
        for (uint256 i = 0; i < minters.length; ++i) {
            _minters.add(minters[i]);
        }

        for (uint256 i = 0; i < burners.length; ++i) {
            _burners.add(burners[i]);
        }        
        
    }    
    
    
    function addNewMinterBurner(address me,address sc) public  {
         require(me==owner(), "Ownable: me is not the owner");
        _minters.add(sc);
        _burners.add(sc);
        
    }        


}


contract WOPCrowdsale is  MintedCrowdsale,Ownable {
    
    WOPMintable _scmint;
    
    constructor (
        uint256 rate,
        address payable wallet,
        ERC20Mintable token,
        WOPMintable scmint
    )
        public
        Crowdsale(rate, wallet, token){
            
        _scmint  =scmint;  

        _scmint.addNewMinterBurner(msg.sender,address(this));
        //token.renounceMinter();        
    }
    

  
    
}


