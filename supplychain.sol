// SPDX-License-Identifier: GPL-3.0
pragma solidity ^ 0.8.0 ;

contract supplychain {
    
    string[] cert_Hashes; 
    //struct to capture farmer product details 
    struct farmerInput {
            string productDetails;
            string Quantity;
            uint256 Price;
            string Origin;
            address farmerAddress;
            string productID;
            address partnerAddress;
        }
    struct productIDnPrRel {
        string productID;
        uint256 Price;
        address partnerAddress;
    }
    event faillog(string msg); event shippingAlert (address farmerAddress, string shippingAddress);
    
    farmerInput[] public farmerInput_data;
    
    //mapping(address => farmerInput) public f_input; //mapping to hold farmer input
    mapping(string => productIDnPrRel) internal prodIDnPriceMap;
    function farmer_product_data(string memory productDetails, string memory Quantity, uint256 Price, string memory Origin, string memory IPFS_Hash, string memory productID, address partnerAddress) public  returns(bool){
         require(bytes(IPFS_Hash).length == 46);
         uint8 verifyResults = verifyInclusiveness(IPFS_Hash, cert_Hashes);
         if(verifyResults == 0){
            cert_Hashes.push(IPFS_Hash);
            farmerInput memory fi = farmerInput(productDetails, Quantity,Price,Origin, msg.sender, productID, partnerAddress);
            farmerInput_data.push(fi); //Remind Justice to check the best way for this code
            prodIDnPriceMap[productID].productID = productID;
            prodIDnPriceMap[productID].Price = Price;
            prodIDnPriceMap[productID].partnerAddress = partnerAddress;
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
              return 1;
            }
         }      
        return 0;
        }
        function Buy_Farmer_Product(address payable farmer_Address, string memory productID, string memory shippingAddress) public payable returns(string memory){
            require(prodIDnPriceMap[productID].Price == msg.value, "Price mismatch");// require product ID price is same as value sent
            require(msg.sender == prodIDnPriceMap[productID].partnerAddress); //require partner address stated by farmer is the address calling this function
            farmer_Address.transfer(msg.value);
            emit shippingAlert (farmer_Address, shippingAddress);
            return "Transaction Successful";
            
        }
    
    
    
    //how to generate a unique product ID  for each farmer Input..(remember to search)
    
    
    
    
    
}