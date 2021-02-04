// SPDX-License-Identifier: GPL-3.0
pragma solidity ^ 0.8.0 ;

// array of validators
//mapping of productID to validators
contract certificate {
    string[] validators; //address of validators
    struct pRID_Val {
        address validator;
        string productID;
        string productDescription;
        string IPFS_Hash;
        string Origin;
    }
    
       mapping(string => pRID_Val) public checkValidator;
       constructor (){
           validators.push("0xe4Abb16Fab2cc9533D7eDA4ff875b14E980B38a4");
           validators.push("0xFE5A0a68F83fae45ff69a2Db003BB2Cba97470fc");
           
       }
       //event to alert validator using his address(val) 
       event Validator_Alert(string productID, string productDescription, string IPFS_Hash, string Origin, string val);
       
    function applyForCert (string memory productID, string memory productDescription, string memory IPFS_Hash, string memory Origin) public returns(bool){
      require (checkValidator[productID].validator == address(0x0), " ProductID already exist "); //check if productid exist by checking if it has an address
       // storing product details in contract
       checkValidator[productID].productDescription = productDescription;
       checkValidator[productID].productID = productID;
       checkValidator[productID].IPFS_Hash = IPFS_Hash;
       checkValidator[productID].Origin = Origin; 
       string memory selectedValidator = randomlySelectedValidator();
       emit Validator_Alert(productID, productDescription, IPFS_Hash, Origin, selectedValidator); //aert validator
       return true;
    }
   function validate() internal returns(bool){
      
       
      
       
   }
    function randomlySelectedValidator() internal view returns(string memory){
        uint8 validatorLoc = 1;
        return validators[validatorLoc];
        
        
    }
    
    }
    
