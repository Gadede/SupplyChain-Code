// SPDX-License-Identifier: GPL-3.0
pragma solidity ^ 0.8.0 ;

contract supplychain {
    
    string[] cert_Hashes; 
    //struct to capture farmer product details 
    struct farmerInput {
            string productDetails;
            string Quantity;
            string Price;
            string Origin;
            address farmerAddress;
        }
    event faillog(string msg); 
    
    mapping(address => farmerInput) internal f_input;
    function farmer_product_data(string memory productDetails, string memory Quantity, string memory Price, string memory Origin, string memory IPFS_Hash ) public  returns(bool){
         require(bytes(IPFS_Hash).length == 46);
         uint8 verifyResults = verifyInclusiveness(IPFS_Hash, cert_Hashes);
         if(verifyResults == 1){
            cert_Hashes.push(IPFS_Hash);
            f_input[msg.sender] = farmerInput(productDetails, Quantity,Price,Origin, msg.sender);
            return true;
         }
         else {
             emit faillog("IPFS Hash already exist");
             return false;
         }
        
    }
    //function to check if IPFS_Hash inputed already exist in the contract
    function verifyInclusiveness(string memory IPFS_Hash, string[] memory certHashes) internal pure returns (uint8){
        for(uint256 i = 0; i < certHashes.length; i++){ 
            if ((keccak256(abi.encodePacked((certHashes[i]))) == keccak256(abi.encodePacked(((IPFS_Hash)))))){ 
            // keccak256(abi.encodePacked converts the cert hash to byte before comparing it             
              return 1; // return 1 if successful
            }
         }      
        return 0; // retrun 0 if unsuccessful
        }
    
    
    
    
    
    
    
    
}