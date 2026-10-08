@EndUserText.label: 'Product Description CDS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZPRODUCT_DES_CDS
provider contract transactional_query
 as projection on I_ProductDescriptionTP_2
{
    key Product,
    key Language,
    ProductDescription
    /* Associations 
    _Product */
}
