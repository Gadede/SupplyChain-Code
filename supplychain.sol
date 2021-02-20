// SPDX-License-Identifier: GPL-3.0
pragma solidity ^ 0.8.0 ;

contract supplychain {
    // IPFS Hash sample: QmWNWLzEAt3Bik6m8GKc1p8zJGc5LGtNDFavSgsAJVRZfn
    
    string[] cert_Hashes; 
    //struct to capture farmer product details 
    struct farmerInput {
            string productDetails;
            string Quantity;
            uint256 Price;
            string Origin;
            address farmerAddress;
            string productID;
            address payable partnerAddress;
        }
    struct productIDnPrRel {
        string productID;
        uint256 Price;
        address partnerAddress;
    }
    
    // relationship between manufacturer and wholesellers
    struct partnerMaps {
        string  productID;
        address payable wholeseller;
        uint256 Price;
        
    }
    
    // struct binding wholesellers to retailers
     struct wholeseller_RetailerMap {
        string  productID;
        address retailer; 
        uint256 Price;
        
    }
    event faillog(string msg); event shippingAlert (address farmerAddress, string shippingAddress);
    
    event payFarmer (string msg); event payManufacturer(string msg); event payWholeseller(string msg);
 
    
    mapping(string => partnerMaps) internal manufacturer_wholeseller_Relationship; //mapping for manufacturer and wholesellers
    
    mapping(string => wholeseller_RetailerMap) internal wholeseller_Retailer_Relationship; //mapping for wholesellers and retailers
    
    mapping(string => farmerInput) internal f_input; //mapping to hold farmer input
    
    mapping(string => productIDnPrRel) internal prodIDnPriceMap;
    
    function farmer_product_data(string memory productDetails, string memory Quantity, uint256 Price, string memory Origin, string memory cert_IPFS_Hash, string memory productID, address payable partnerAddress) public  returns(bool){
         require(bytes(cert_IPFS_Hash).length == 46);
         uint8 verifyResults = verifyInclusiveness(cert_IPFS_Hash, cert_Hashes);
         if(verifyResults == 0){
             
             //get productID and cert status from provable
             // check msg.sender matches farmer address
             //check productID matches input parameter
             //require that cert status is approved
             
            cert_Hashes.push(cert_IPFS_Hash);
            f_input[productID] = farmerInput(productDetails, Quantity,Price,Origin, msg.sender, productID, partnerAddress);
            prodIDnPriceMap[productID] = productIDnPrRel(productID, Price, partnerAddress);
            
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
    function Buy_Farmer_Product(address payable farmer_Address, string memory productID, string memory shippingAddress, address payable wholeseller) public payable returns(string memory){
            require(prodIDnPriceMap[productID].Price == msg.value, "Price mismatch");// require product ID price is same as value sent
            require(msg.sender == prodIDnPriceMap[productID].partnerAddress); //require partner address stated by farmer is the address calling this function
            farmer_Address.transfer(msg.value);
            emit payFarmer(" Farmer Payment Successful");
            manufacturer_wholeseller_Relationship[productID].productID = productID;
            manufacturer_wholeseller_Relationship[productID].wholeseller = wholeseller;
            emit shippingAlert (farmer_Address, shippingAddress);
            return "Transaction Successful";
            
        }
    function setWholesalePrice(string memory productID, uint256 Price) public payable returns(bool){
      require (f_input[productID].partnerAddress == msg.sender);
      manufacturer_wholeseller_Relationship[productID].Price = Price;
      return true;
       
        
    }
        
    function assetTransfer_wholseller(string memory productID, address retailer) public payable returns(bool){
        require( manufacturer_wholeseller_Relationship[productID].wholeseller == msg.sender);
        require(manufacturer_wholeseller_Relationship[productID].Price == msg.value, "Price mismatch");
        f_input[productID].partnerAddress.transfer(msg.value);
        emit payManufacturer(" manufacturer Payment Successful");
        
        wholeseller_Retailer_Relationship[productID].retailer = retailer;
        return true;
        
        
    }
    function setRetailPrice(string memory productID, uint256 Price) public payable returns(bool){
      require (manufacturer_wholeseller_Relationship[productID].wholeseller == msg.sender);
      wholeseller_Retailer_Relationship[productID].Price = Price;
      return true;
    }
    
    function assetTransfer_retailer(string memory productID) public payable returns(bool){
        require( wholeseller_Retailer_Relationship[productID].retailer == msg.sender);
        require(wholeseller_Retailer_Relationship[productID].Price == msg.value, "Price mismatch");
        manufacturer_wholeseller_Relationship[productID].wholeseller.transfer(msg.value);
        emit payWholeseller(" wholeseller Payment Successful");
        return true;

    }
    
    
    //how to generate a unique product ID  for each farmer Input..(remember to search)
    
    
    
    
    
}