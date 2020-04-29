<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" schemaVersion="iso"
  queryBinding="xslt2">

	<title>Icelandic invoice rules</title>
  
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl-creditnote"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl-invoice"/>
	<ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
	<ns uri="utils" prefix="u"/>

	<pattern>
		<let name="SupplierCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
		<let name="CustomerCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>

		<rule context="ubl-creditnote:CreditNote[$SupplierCountry = 'IS'] | ubl-invoice:Invoice[$SupplierCountry = 'IS']">
		<!-- status draft -->
			<assert 
				id="IS-R-001"
				test="( ( not(contains(normalize-space(cbc:InvoiceTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(cbc:InvoiceTypeCode),' ') ) ) )"
				flag="warning">[IS-R-001]-If seller is icelandic then invoice type should be 380 or 381 — Ef seljandi er íslenskur þá ætti gerð reiknings (BT-3) að vera sölureikningur (380) eða kreditreikningur (381).</assert>

		<!-- status draft -->
			<assert 
				id="IS-R-002"
				test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'"
				flag="fatal">[IS-R-002]-If seller is icelandic then it shall contain sellers legal id — Ef seljandi er íslenskur þá skal reikningur innihalda íslenska kennitölu seljanda (BT-30).</assert>

		<!-- status draft -->
			<assert 
				id="IS-R-003"
				test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone)"
				flag="fatal">[IS-R-003]-If seller is icelandic then it shall contain his address with street name and zip code — Ef seljandi er íslenskur þá skal heimilisfang seljanda innihalda götuheiti og póstnúmer (BT-35 og BT-38).</assert>

		<!-- status draft -->
			<assert 
				id="IS-R-006"
				test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID) 
					  and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)) = 12
					  or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']))"
				flag="fatal">[IS-R-006]-If seller is icelandic and payment means code is 9 then a 12 digit account id must exist  — Ef seljandi er íslenskur og greiðslumáti (BT-81) er millifærsla (kóti 9) þá skal koma fram 12 stafa reikningnúmer (BT-84)</assert>

		<!-- status draft -->
			<assert 
				id="IS-R-007"
				test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID) 
					  and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)) = 12
					  or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']))"
				flag="fatal">[IS-R-007]-If seller is icelandic and payment means code is 42 then a 12 digit account id must exist  — Ef seljandi er íslenskur og greiðslumáti (BT-81) er millifærsla (kóti 42) þá skal koma fram 12 stafa reikningnúmer (BT-84)</assert>
				
<!-- status draft -->
			<assert 
				id="IS-R-008"
				test="(exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '71']) and string-length(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '71']/cbc:ID) = 10 and (string(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '71']/cbc:ID) castable as xs:date)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '71']))"
				flag="fatal">[IS-R-008]-If seller is icelandic and invoice contains reference type 71 then the id form must be YYYY-MM-DD — Ef seljandi er íslenskur þá skal eindagi (BT-122, tegundarkóti 71) vera á forminu YYYY-MM-DD.</assert>
<!-- status draft -->
			<assert 
				id="IS-R-009"
				test="(exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '71']) and exists(cbc:DueDate)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '71']))"
				flag="fatal">[IS-R-009]-If seller is icelandic and invoice contains reference type 71 invoice must have due date — Ef seljandi er íslenskur þá skal reikningur sem inniheldur eindaga (BT-122, DocumentTypeCode = 71) einnig hafa gjalddaga (BT-9).</assert>
<!-- status draft -->
			<assert 
				id="IS-R-010"
				test="(exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '71']) and (cbc:DueDate) &lt;= (cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '71']/cbc:ID)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '71']))"
				flag="fatal">[IS-R-010]-If seller is icelandic and invoice contains reference type 71 the id date must be same or later than due date — Ef seljandi er íslenskur þá skal eindagi (BT-122, DocumentTypeCode = 71) skal vera sami eða síðar en gjalddagi (BT-9) ef eindagi er til staðar.</assert>
				
		</rule>
		<rule context="ubl-creditnote:CreditNote[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty | ubl-invoice:Invoice[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty">
<!-- status draft -->
			<assert 
				id="IS-R-004"
				test="exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'"
				flag="fatal">[IS-R-004]-If seller and buyer are icelandic then the invoice shall contain the buyers icelandic legal identifier — Ef seljandi og kaupandi eru íslenskir þá skal reikningurinn innihalda íslenska kennitölu kaupanda (BT-47).</assert>

<!-- status draft -->
			<assert 
				id="IS-R-005"
				test="exists(cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:Party/cac:PostalAddress/cbc:PostalZone)"
				flag="fatal">[IS-R-005]-If seller and buyer are icelandic then the invoice shall contain the buyers address with street name and zip code  — Ef seljandi og kaupandi eru íslenskir þá skal heimilisfang kaupanda innihalda götuheiti og póstnúmer (BT-50 og BT-53)</assert>

		</rule>
	</pattern>
</schema>
