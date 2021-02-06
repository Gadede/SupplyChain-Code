// SPDX-License-Identifier: GPL-3.0
pragma solidity ^ 0.8.0 ;

// array of validators
//mapping of productID to validators
contract certificate {
    string[] validators; //address of validators
    address admin;
    struct pRID_Val {
        string validator; //address of validator
        string productID;
        string productDescription;
        string IPFS_Hash;
        string Origin;
        string cert_IPFS_Hash;
        uint8 cert_Status; // 1 for approved 0 for denied.
        
    }
    
       mapping(string => pRID_Val) public checkValidator;
       constructor (){
           validators.push("0xe4Abb16Fab2cc9533D7eDA4ff875b14E980B38a4");
           validators.push("0xFE5A0a68F83fae45ff69a2Db003BB2Cba97470fc");
           admin = msg.sender;
       }
       //event to alert validator using his address(val) 
       event Validator_Alert(string productID, string productDescription, string IPFS_Hash, string Origin, string val, string farmerSig);
       event farmerAlert (string productID, string cert_Status);
       
    function applyForCert (string memory productID, string memory productDescription, string memory IPFS_Hash, string memory Origin, string memory farmerSig) public returns(bool){
      require (bytes(checkValidator[productID].validator).length == 0 ," ProductID already exist "); //check if productid exist by checking if it has an address
       // storing product details in contract
       checkValidator[productID].productDescription = productDescription;
       checkValidator[productID].productID = productID;
       checkValidator[productID].IPFS_Hash = IPFS_Hash;
       checkValidator[productID].Origin = Origin; 
       string memory selectedValidator = randomlySelectedValidator();
       checkValidator[productID].validator = selectedValidator; 
       emit Validator_Alert(productID, productDescription, IPFS_Hash, Origin, selectedValidator, farmerSig); //aert validator //validator will extract farmer public key from signature
       return true;
    }
   function validate(string memory productID, string memory cert_IPFS_Hash, uint8 cert_Status) public returns(bool){
       checkValidator[productID].cert_IPFS_Hash = cert_IPFS_Hash; // storing cert_IPFS_Hashs in mapping
       checkValidator[productID].cert_Status = cert_Status; //storing cert_Status in mapping
       if (cert_Status == 1) {
            emit farmerAlert (productID, "Approved Product");
       }else{
           emit farmerAlert ( productID,"Prodcut Denied");
       }
      
       return true;
   }
    function randomlySelectedValidator() internal view returns(string memory){
        uint8 validatorLoc = 1;
        return validators[validatorLoc];
        
        
    }
    //function to add validator to the array of validators
    function addValidator (string memory validator) public returns(uint8){
        require(msg.sender == admin);
        validators.push(validator);
        return 1; 
    }
    //function to delete validator from list of validators
    function delValidator(string memory validator) public  returns(uint8){
        require (msg.sender == admin);
        removeByValue(validator);
        return 1;
    }
     function find(string memory addr) internal view returns(uint) {
        uint i = 0;
        while ( keccak256(abi.encodePacked(validators[i])) != keccak256(abi.encodePacked(addr))) {
            i++;
        }
        return i;
    }

    function removeByValue(string memory addr) internal {
        uint i = find(addr);
        removeByIndex(i);
    }

    function removeByIndex(uint i) internal {
        while (i<validators.length-1) {
            validators[i] = validators[i+1];
            i++;
        }
        //validators.length--; //pending on how to solve this 
    }
    
    function showValidators () public view returns(string[] memory){
        return validators;
    }
    }
    
