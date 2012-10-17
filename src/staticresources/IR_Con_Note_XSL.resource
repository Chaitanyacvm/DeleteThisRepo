<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:variable name="absoluteResourcesDir" select="'http://iconnection.tnt.com:81/Shipper/NewStyleSheets'"/>
	<xsl:variable name="hostName" select="'https://my.tnt.com/'"/>

	<xsl:template match="/">
		<html>
			<head>

				<script type="text/javascript"><![CDATA[
					
					var firstPagePrinted = false;

					function includePageBreak() {

						if (firstPagePrinted) {
							document.writeln('<div class="pagebreak">');
							document.writeln('<font size="1" color="#FFFFFF">.</font>');
							document.writeln('</div>');
						} else {
							firstPagePrinted = true;
						}

					}					
					
					function barCode(barString) {
						var myCode = new Array();
						var grow = "";
						for (var i = 0; i != barString.length; i++) {
							
							var myChar = barString.charAt(i);
							
							if (myChar == "*") {
								myCode[i] = "bc_star.gif";
							} else {
								myCode[i] = "bc_" + myChar + ".gif";
							}
						}

						for (var i=0; i != myCode.length; i++) {
							grow = grow +'<img width="14" height="60" src="http://iconnection.tnt.com:81/Shipper/barcode/' + myCode[i] + '" />';
						}
					
						return grow;
					}
					]]>

				</script>

				<style><![CDATA[
				
				/* International Styles /*
				div { page-break-after: always } 

				font.header { color : black; background-color : white; font-weight : bold; font-family : arial, helvetica "sans-serif"; font-size : 8pt; } 

				font.data { color : black; background-color : white; font-family : arial , "sans-serif"; font-size : 8pt; }

				font.sender { color : black; background-color : white; font-family : arial , "sans-serif"; font-size : 6pt; }

				font.smallprint { color : black; background-color : white; font-family : arial, "sans-serif"; font-size : 8pt; }

				font.customs { color : black; background-color : white; font-weight : bold; font-family : arial, "sans-serif"; font-size : 12pt; } 

				font.received { color : black; background-color : white; font-family : arial, , "sans-serif"; font-size : 8pt; }

				
				/* UK Domestic Styles */
				.senderAddress{ line-height: 2mm; }

				.deliveryAddress{ line-height: 3mm; }
				
				.table1{  height: 25mm;	 }

				.table1td1{  width: 56mm; height: 25mm; border-right: 1px solid #000000; }

				.table1td1table{ width: 56mm; height: 25mm; }

				.table1td2{ height: 17mm; border-bottom: 1px solid #000000; }

				.table1td3{ height: 8mm; }

				.table2td1{  width: 64mm; border-right: 1px solid #000000; }

				.table2td1table{  width: 64mm; }

				.table3{ height: 8mm; }

				.table3td1{ width: 84mm; height: 8mm; border-right: 1px solid #000000; }

				.table3td2{  height: 8mm; }

				.table4td1{  width: 67mm; border-right: 1px solid #000000; }

				.table4td2{  width: 31mm; border-right: 1px solid #000000;  }


				font.addressHeader  {  color : black;  font-weight : bold;  font-family :  "arial";  font-size : 6pt;   } 

				font.addressHeaderCode  {  color : black;  font-weight : bold;  font-family :  "arial";  font-size : 8pt;  letter-spacing: 0.2cm   } 

				font.barcode  {  color : black;  font-weight : bold;  font-family :  "arial";  font-size : 8pt;  letter-spacing: 0.1cm   } 

				font.addressHeaderRec  {  color : black;  font-weight : bold;  font-family : "arial";  font-size : 6pt;   } 

				font.addressData  {  color : black;  font-family : "courier new";  font-size : 8pt;  }

				font.addressDataRec  {  color : black;  font-weight : bold;  font-family : "courier new";  } 

				font.addressDataWeight  {  color : black;  font-weight : bold;  font-family : "courier new";  font-size : 11pt;  }

				font.addressSmallPrint  {  font-family : "courier new";  font-size : 4pt;  }

				font.addressSmallPrintLink  {  font-family : "courier new";  font-size : 5pt;  }

				font.header {  color : black;  font-weight : bold;  font-family : arial, helvetica "sans-serif";  font-size : 8pt;   } 

				font.invoiceHeader {  color : black;  background-color : white;  font-weight : bold;  font-family : arial, helvetica "sans-serif";  font-size : 10pt;   } 

				font.data {  color : black;  font-family : arial , "sans-serif";  font-size : 8pt;  }

				font.smallprint {  color : black;  background-color : white;  font-family : arial, "sans-serif";  font-size : 6pt;  }

				font.smallprintlink {  color : black;  background-color : white;  font-family : arial, "sans-serif";  font-size : 7pt;  }

				font.auSmallPrint {  color : black;  background-color : white;  font-family : arial, "sans-serif";  font-size : 7pt;  }

				font.auSmallPrintLink {  color : black;  background-color : white;  font-family : arial, "sans-serif";  font-size : 7pt;   text-decoration:underline;  }

				font.carrierLicence  {  color : black;  font-family : "courier new";  font-size : 7pt;  } 

				.normalService {  font-size: x-large;  }

				.premiumService {   font-size: xx-large;  font-weight: bold;  }

				.tntTelephone {  font-size: small;  }

				.deliveryDepot {  font-size: 96px;  }

				.data {  }

				.dataBold {  font-weight: bold;  }

				.label {  }

				.deliveryPostcode {  font-size: xx-large;  font-weight: bold;  }

				table.outLine {  border: 1px solid #656566;  border-collapse : collapse;  padding : 1px;  background-color: #FFFFFF;  }

				td.outLineCell {  border: 1px solid #656566;  } 

				div.pagebreak {  page-break-before : always;  }

				font.sm-data {   color : black;   background-color : white;   font-family : arial, helvetica "sans-serif";   font-size : 6pt;  }

				font.sm-field {   color : black;   background-color : white;   font-weight : bold;   font-family : arial, helvetica "sans-serif";   font-size : 6pt;  }

				font.sm-title {   color : black;   background-color : white;   font-weight : bold;   font-family : arial, helvetica "sans-serif";   font-size : 9pt;   text-decoration:underline;  }

				font.serviceCode {    color : black;  font-weight : bold;  font-family : arial;  font-size : 18pt;   }

				font.operationsFlow {    color : black;  font-weight : bold;  font-family : arial;  font-size : 24pt;   }

				font.productCode {    color : black;  font-weight : bold;  font-family : arial;  font-size : 12pt;   }  

				font.postProduct {    color : black;  font-family : arial;  font-size : 10pt;   }  

				font.domestic {    color : black;  font-weight : bold;  font-family : arial;  font-size : 16pt;   }


				]]>
				</style>
			</head>
			<body>

				<xsl:for-each select="/CONSIGNMENTBATCH/CONSIGNMENT">

					<xsl:choose>

						<xsl:when test="@marketType='DOMESTIC'">
							<xsl:choose>
								<xsl:when test="@originCountry='GB'">
									<xsl:call-template name="UKDomesticConNote">
										<xsl:with-param name="copyFor">C</xsl:with-param>
										<xsl:with-param name="returns">false</xsl:with-param>
									</xsl:call-template>

									<xsl:call-template name="UKDomesticConNote">
										<xsl:with-param name="copyFor">P</xsl:with-param>
										<xsl:with-param name="returns">false</xsl:with-param>
									</xsl:call-template>
								</xsl:when>

								<xsl:otherwise>

									<xsl:call-template name="InternationalTemplate">

										<xsl:with-param name="whosCopy" select="'C'"/>
									</xsl:call-template>

									<xsl:call-template name="InternationalTemplate">
										<xsl:with-param name="whosCopy" select="'R'"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<xsl:otherwise>
							<xsl:call-template name="InternationalTemplate">
								<xsl:with-param name="whosCopy" select="'C'"/>
							</xsl:call-template>

							<xsl:call-template name="InternationalTemplate">
								<xsl:with-param name="whosCopy" select="'R'"/>
							</xsl:call-template>
						</xsl:otherwise>

					</xsl:choose>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="InternationalTemplate">

		<xsl:param name="whosCopy"/>
		 

		 
			<script>includePageBreak();</script>
		 

 		<table width="600" cellpadding="0" cellspacing="0" border="1">
			<tr>
				<!-- left table column start -->
				<td valign="top" width="300" align="center">
					<table width="300" cellpadding="0" cellspacing="1" border="0">
						<!-- start of 1. From -->

						<xsl:choose>
							<xsl:when test="HEADER/COLLECTION/COMPANYNAME/text()">
								<tr>
									<td colspan="4">
										<font class="header">1.From (Collection Address)</font>
										<br/>
										<hr size="1" noshade="noshade" width="100%"/>
										<font class="data">Sender's Account No : <xsl:value-of select="HEADER/SENDER/ACCOUNT"/><br/>Name : <xsl:value-of select="HEADER/COLLECTION/COMPANYNAME"/><br/>Address : <xsl:value-of select="HEADER/COLLECTION/STREETADDRESS1"/><br/><xsl:if test="HEADER/COLLECTION/STREETADDRESS2/text()"><xsl:value-of select="HEADER/COLLECTION/STREETADDRESS2"/><br/></xsl:if><xsl:if test="HEADER/COLLECTION/STREETADDRESS3/text()"><xsl:value-of select="HEADER/COLLECTION/STREETADDRESS3"/></xsl:if></font>

									</td>
								</tr>

								<tr>
									<td colspan="2">
										<font class="data">City : <xsl:value-of select="HEADER/COLLECTION/CITY"/><br/>Province : <xsl:value-of select="HEADER/COLLECTION/PROVINCE"/><br/>Contact Name : <xsl:value-of select="HEADER/COLLECTION/CONTACTNAME"/></font>
									</td>

									<td colspan="2">
										<font class="data">Postal/Zip Code : <xsl:value-of select="HEADER/COLLECTION/POSTCODE"/><br/>Country : <xsl:value-of select="HEADER/COLLECTION/COUNTRY"/><br/>Tel No : <xsl:value-of select="HEADER/COLLECTION/CONTACTDIALCODE"/>&#160;<xsl:value-of select="HEADER/COLLECTION/CONTACTTELEPHONE"/></font>
									</td>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<tr>

									<td colspan="4">
										<font class="header">1.From (Collection Address)</font>
										<br/>
										<hr size="1" noshade="noshade" width="100%"/>
										<font class="data">Sender's Account No : <xsl:value-of select="HEADER/SENDER/ACCOUNT"/><br/>Name : <xsl:value-of select="HEADER/SENDER/COMPANYNAME"/><br/>Address : <xsl:value-of select="HEADER/SENDER/STREETADDRESS1"/><br/><xsl:if test="HEADER/SENDER/STREETADDRESS2/text()"><xsl:value-of select="HEADER/SENDER/STREETADDRESS2"/><br/></xsl:if><xsl:if test="HEADER/SENDER/STREETADDRESS3/text()"><xsl:value-of select="HEADER/SENDER/STREETADDRESS3"/></xsl:if></font>
									</td>
								</tr>

								<tr>
									<td colspan="2">
										<font class="data">City : <xsl:value-of select="HEADER/SENDER/CITY"/><br/>Province : <xsl:value-of select="HEADER/SENDER/PROVINCE"/><br/>Contact Name : <xsl:value-of select="HEADER/SENDER/CONTACTNAME"/></font>
									</td>

									<td colspan="2">
										<font class="data">Postal/Zip Code : <xsl:value-of select="HEADER/SENDER/POSTCODE"/><br/>Country : <xsl:value-of select="HEADER/SENDER/COUNTRY"/><br/>Tel No : <xsl:value-of select="HEADER/SENDER/CONTACTDIALCODE"/>&#160;<xsl:value-of select="HEADER/SENDER/CONTACTTELEPHONE"/></font>

									</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>

						<!-- start of 2. Receiver -->

						<tr>
							<td colspan="4">
								<font class="header">

									<br/>2.To (Receiver Address)</font>
								<br/>
								<hr size="1" noshade="noshade" width="100%"/>
								<font class="data">Name : <xsl:value-of select="RECEIVER/COMPANYNAME"/><br/>Address : <xsl:value-of select="RECEIVER/STREETADDRESS1"/><br/><xsl:if test="RECEIVER/STREETADDRESS2/text()"><xsl:value-of select="RECEIVER/STREETADDRESS2"/><br/></xsl:if><xsl:if test="RECEIVER/STREETADDRESS3/text()"><xsl:value-of select="RECEIVER/STREETADDRESS3"/></xsl:if></font>
							</td>
						</tr>

						<tr>

							<td colspan="2">
								<font class="data">City : <xsl:value-of select="RECEIVER/CITY"/><br/>Province : <xsl:value-of select="RECEIVER/PROVINCE"/><br/>Contact Name : <xsl:value-of select="RECEIVER/CONTACTNAME"/></font>
							</td>

							<td colspan="2">
								<font class="data">Postal/Zip Code : <xsl:value-of select="RECEIVER/POSTCODE"/><br/>Country : <xsl:value-of select="RECEIVER/COUNTRY"/><br/>Tel No : <xsl:value-of select="RECEIVER/CONTACTDIALCODE"/>&#160;<xsl:value-of select="RECEIVER/CONTACTTELEPHONE"/></font>

							</td>
						</tr>

						<!-- start of 3. Goods -->
						<tr>
							<td colspan="4">
								<font class="header">
									<br/>3.Goods</font>
								<br/>

								<hr size="1" noshade="noshade" width="100%"/>
								<font class="data">General Description :<br/><xsl:value-of select="GOODSDESC1"/><br/><xsl:if test="GOODSDESC2/text()"><xsl:value-of select="GOODSDESC2"/><br/></xsl:if><xsl:if test="GOODSDESC3/text()"><xsl:value-of select="GOODSDESC3"/></xsl:if></font>
							</td>
						</tr>

						<!-- SR 2191 Stat No -->
						<tr>
							<td colspan="4">&#160;</td>
						</tr>

						<tr>
							<td colspan="1">
								<font class="data">Stat No :</font>
							</td>
							<td colspan="3">
								<font class="data"><xsl:value-of select="STATCODE"/></font>
							</td>
						 
						</tr>

						<tr>
							<td colspan="1">
								<font class="data">Total Packages :</font>
							</td>
							<td colspan="1">
								<font class="data">Total Weight :</font>
							</td>

							<td colspan="1">
								<font class="data">Total Volume :</font>
							</td>
							<td colspan="1"></td>
						</tr>

						<tr>
							<td colspan="1">
								<font class="data">

									<xsl:value-of select="TOTALITEMS"/>
								</font>
							</td>
							<td colspan="1">
								<font class="data">
									<xsl:value-of select="TOTALWEIGHT"/>&#160;<xsl:value-of select="TOTALWEIGHT/@units"/></font>
							</td>

							<td colspan="1">

								<font class="data">
									<xsl:value-of select="TOTALVOLUME"/>&#160;<xsl:value-of select="TOTALVOLUME/@units"/></font>
							</td>

							<td colspan="1"></td>
						</tr>

						<!-- start of 4. Services -->
						<tr>
							<td colspan="4">

								<font class="header">
									<br/>4. Services</font>
								<br/>
								<hr size="1" noshade="noshade" width="100%"/>
								<font class="data">Service : <xsl:value-of select="SERVICE"/><br/>Options : <xsl:value-of select="OPTION1"/><br/><xsl:if test="OPTION2/text()"><xsl:value-of select="OPTION2"/>&#160;</xsl:if><xsl:if test="OPTION3/text()"><xsl:value-of select="OPTION3"/></xsl:if></font>
							</td>
						</tr>

						<tr>
							<td colspan="3">
								<font class="data">
									<xsl:if test="OPTION4/text()">
										<xsl:value-of select="OPTION4"/>&#160;</xsl:if>
									<xsl:if test="OPTION5/text()">
										<xsl:value-of select="OPTION5"/>
									</xsl:if>

								</font>
							</td>
							<td colspan="1">
								<font class="sender">
									<xsl:if test="PAYMENTIND = 'S'">Sender Pays</xsl:if>
									<xsl:if test="PAYMENTIND='R'">Receiver Pays</xsl:if>
								</font>
							</td>

						</tr>

						<tr>
							<td colspan="3">
								<font class="data">Insurance Currency : <xsl:value-of select="INSURANCECURRENCY"/></font>
							</td>
							<td colspan="1">
								<font class="data">Value : <xsl:value-of select="INSURANCEVALUE"/></font>

							</td>
						</tr>

						<tr>
							<td colspan="4">
								<hr size="1" noshade="noshade" width="100%"/>
							</td>
						</tr>

						<tr>

							<td colspan="4">
								<font class="received">
									<br/>Sender's Signature : ______________________________</font>
							</td>
						</tr>

						<tr>
							<td colspan="4">
								<font class="received">

									<br/>Date : ____/____/____</font>
								<br/>
							</td>
						</tr>

						<tr>
							<td colspan="4">
								<font class="smallprint">
									<br/>LIABILITY FOR LOSS, DAMAGE AND DELAY IS LIMITED BY THE CMR CONVENTION OR THE WARSAW CONVENTION WHICHEVER IS APPLICABLE.THE SENDER AGREES THAT THE GENERAL CONDITIONS, ACCESSIBLE VIA THE HELP TEXT THAT ARE ACCEPTABLE AND GOVERN THIS CONTRACT.IF NO SERVICE OR BILLING OPTION IS SELECTED THE FASTEST AVAILABLE SERVICE WILL BE CHARGED TO THE SENDER</font>

							</td>
						</tr>
					</table>
				</td>

				<!-- left table column end-->

				<!-- right table column start-->
				<td valign="top" width="300" align="center">
					<table width="300" cellpadding="1" cellspacing="0" border="0">

						<!-- start of TNT logo -->
						<tr>
							<td colspan="2" align="center">
								<img src="http://iconnection.tnt.com:81/images/logo.gif"/>
							</td>
						</tr>




						<tr align="center">

							<td colspan="2">
								<br/>
								<script language="JavaScript" type="text/javascript">document.write(barCode('*<xsl:value-of select="CONNUMBER"/>*'));</script>
							</td>
						</tr>
						<tr>
							<td align="center" colspan="2">
								<font class="data">*<xsl:value-of select="CONNUMBER"/>*<br/>Please quote this number if you have an enquiry.</font>

							</td>
						</tr>




						<!-- start of A. Delivery -->
						<tr>
							<td colspan="2">
								<font class="header">
									<br/>A. Delivery Address</font>

								<br/>
								<hr size="1" width="100%" noshade="noshade"/>
								<font class="data">Name : <xsl:value-of select="DELIVERY/COMPANYNAME"/><br/>Address : <xsl:value-of select="DELIVERY/STREETADDRESS1"/><br/><xsl:if test="DELIVERY/STREETADDRESS2/text()"><xsl:value-of select="DELIVERY/STREETADDRESS2"/><br/></xsl:if><xsl:if test="DELIVERY/STREETADDRESS3/text()"><xsl:value-of select="DELIVERY/STREETADDRESS3"/></xsl:if></font>
							</td>
						</tr>

						<tr>
							<td colspan="1">

								<font class="data">City : <xsl:value-of select="DELIVERY/CITY"/><br/>Province : <xsl:value-of select="DELIVERY/PROVINCE"/>	<br/>Contact Name : <xsl:value-of select="DELIVERY/CONTACTNAME"/></font>
							</td>

							<td colspan="1">
								<font class="data">Postal/Zip Code : <xsl:value-of select="DELIVERY/POSTCODE"/><br/>Country : <xsl:value-of select="DELIVERY/COUNTRY"/><br/>Tel No : <xsl:value-of select="DELIVERY/CONTACTDIALCODE"/>&#160;<xsl:value-of select="DELIVERY/CONTACTTELEPHONE"/></font>
							</td>

						</tr>

						<!-- start of B. Dutible Shipment Details -->
						<tr>
							<td colspan="4">
								<font class="header">
									<br/>B. Dutiable Shipment Details</font>
								<br/>
								<hr size="1" noshade="noshade" width="100%"/>

								<font class="data">Receivers VAT/TVA/BTW/MWST No. : <xsl:value-of select="RECEIVER/VAT"/><br/>Invoice Value of Dutiables</font>
							</td>
						</tr>

						<tr>
							<td colspan="1">
								<font class="data">Currency:<xsl:value-of select="CURRENCY"/></font>
							</td>

							<td colspan="1">
								<font class="data">Value:<xsl:value-of select="GOODSVALUE"/></font>
							</td>
						</tr>


						<!-- start of C. Special Delivery Instructions -->
						<tr>
							<td colspan="2">

								<font class="header">
									<br/>C. Special Delivery Instructions</font>
								<br/>
								<hr size="1" noshade="noshade" width="100%"/>
								<font class="data">
									<xsl:value-of select="DELIVERYINST"/>
								</font>
								<!-- start of D. Customer Reference -->

								<font class="header">
									<br/>
									<br/>D. Customer Reference</font>
								<br/>
								<hr size="1" noshade="noshade" width="100%"/>
								<font class="data">
									<xsl:value-of select="CUSTOMERREF"/>
								</font>

								<!-- start of E. Invoice DELIVERY (DELIVERY's Account Number) -->
								<font class="header">
									<br/>
									<br/>E. Invoice Receiver (Receiver's Account Number)</font>
								<br/>
								<hr size="1" noshade="noshade" width="100%"/>
								<font class="data">
									<xsl:value-of select="RECEIVER/ACCOUNT"/>

								</font>
								<br/>
								<hr size="1" noshade="noshade" width="100%"/>
								<font class="received">
									<br/>Received by TNT <br/>by (Name) : _____________________________________</font>
								<br/>
								<br/>
								<font class="received">Date : ____/____/____ &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Time : ____:____</font>

								<br/>
								<font class="customs">
									<br/>
									<xsl:choose>
										<xsl:when test="$whosCopy = 'C'">Custom&apos;s Copy</xsl:when>
										<xsl:when test="$whosCopy = 'R'">Receiver&apos;s Copy</xsl:when>
									</xsl:choose>

								</font>
								<br/>Please Keep For Reference</td>
						</tr>
					</table>
				</td>
			</tr>

			<!--horizontal line at bottom of table -->

			<!--end of main table custom's copy-->
		</table>
	</xsl:template>


	<xsl:template name="UKDomesticConNote">
		<xsl:param name="copyFor"/>
		<xsl:param name="returns"/>
		 
		 
			<script>includePageBreak();</script>

		 

		<table bgcolor="#ff6600" border="0" cellspacing="1" cellpadding="0" width="600">
			<tr>
				<td valign="top" width="50%">
					<!-- LEFT HAND COLUMN -->
					<table width="100%" cellpadding="0" cellspacing="1" border="0" bordercolor="#33FF33">
						<tr>
							<td>
								<table width="100%" class="outLine">
									<tr>

										<td nowrap="nowrap">
											<img src="{$absoluteResourcesDir}/images/lg_tnt_uk_sml.gif" width="52" height="20"/>
											<br class=""/>
											<font class="smallprint">TNT EXPRESS HOUSE, HOLLY LANE,<br class=""/>
                  ATHERSTONE, WARWICKSHIRE CV9 2RY <br class=""/>
                  TELEPHONE : 01827 303030</font>
										</td>

										<td nowrap="nowrap">
											<font class="header">EXPRESS</font>
											<br class=""/>
											<xsl:choose>
												<xsl:when test="$copyFor = 'C'">
													<font class="data">Customer Copy</font>
												</xsl:when>
												<xsl:otherwise>

													<font class="data">Pricing Copy</font>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td nowrap="nowrap" class="outLineCell" align="center">
											<font class="data">Div</font>
											<br class=""/>
											<font class="dataBold">010</font>

										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
							</td>

						</tr>
						<tr>
							<td>
								<table width="100%" class="outLine" style="background-color: #FDBA8D">
									<tr>
										<td width="65%">
											<font class="header">SENDER&apos;S ACCOUNT NUMBER</font>
										</td>

										<td width="15%">
											<font class="data">
												<xsl:value-of select="HEADER/SENDER/ACCOUNT"/>
											</font>
										</td>
										<td width="20%">
										</td>
									</tr>
								</table>

							</td>
						</tr>
						<tr>
							<td>
								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
							</td>
						</tr>
						<tr>
							<td>

								<font class="header">FROM (Sender)</font>
							</td>
						</tr>
						<tr>
							<td>
								<xsl:choose>
									<xsl:when test="$returns != 'true'">
										<xsl:choose>

											<xsl:when test="HEADER/COLLECTION/COMPANYNAME/text()">
												<xsl:call-template name="ukDomesticCollectionAddress"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="ukDomesticSenderAddress"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>

									<xsl:otherwise>
										<!-- Reverse the Collection/delivery and Sender/Receiver addresses for a returns consignment -->
										<xsl:choose>

											<xsl:when test="DELIVERY/COMPANYNAME/text()">
												<xsl:call-template name="UKDomesticDeliveryAddress"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="UKDomesticReceiverAddress"/>

											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<tr>
							<td>
								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>

							</td>
						</tr>
						<tr>
							<td>
								<table width="100%" class="outLine" style="background-color: #FDBA8D">
									<tr>
										<td>
											<font class="header">CUSTOMER REFERENCE</font>

										</td>
									</tr>
									<tr>
										<td>
											<font class="data">
												<xsl:value-of select="substring(CUSTOMERREF, 1, 15)"/>
											</font>
										</td>
									</tr>

								</table>
							</td>
						</tr>
						<tr>
							<td>
								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
							</td>
						</tr>
						<tr>

							<td height="18" valign="bottom">
								<font class="header">TO (Receiver)</font>
							</td>
						</tr>
						<tr>
							<td>
								<xsl:choose>
									<xsl:when test="$returns != 'true'">

										<xsl:choose>

											<xsl:when test="DELIVERY/COMPANYNAME/text()">
												<xsl:call-template name="UKDomesticDeliveryAddress"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="UKDomesticReceiverAddress"/>
											</xsl:otherwise>
										</xsl:choose>

									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="UKDomesticReceiverAddress"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<tr>
							<td>

								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
							</td>
						</tr>
						<tr>
							<td>

								<table height="67" class="outLine" width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td>

											<font class="header">SENDER&apos;S SIGNATURE</font>
										</td>
										<td>
											<font class="header">(Please Print)</font>
										</td>
									</tr>
									<tr>

										<td>
											<img height="30" width="1" src="{$absoluteResourcesDir}/images/1x1.gif"/>
										</td>
									</tr>

									<tr>
										<td>
											<font class="header">Date</font>
											<font class="smallPrint">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;/&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;/&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</font>

											<font class="smallprint">(Day/Month/Year)</font>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<!-- END OF LEFT HAND COLUMN -->

				</td>
				<td valign="top" width="50%">
					<!-- RIGHT HAND COLUMN -->
					<table cellspacing="1" cellpadding="0" width="100%">
						<tr>
							<td>
								<table height="85" cellpadding="0" cellspacing="0" border="0" width="100%">
									<tr>
										<td class="outLineCell" bgcolor="#FFFFFF" align="center">

											<font class="header">CONSIGNMENT NOTE NUMBER<br class=""/>

												<img src="{$hostName}/barcode/barbecue?data={CONNUMBER}&amp;type=Code128&amp;height=70" width="160"/>
												<br class=""/>
												<xsl:value-of select="CONNUMBER"/>
											</font>
										</td>
										<td>
											<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="30"/>

										</td>
										<td class="outLineCell" bgcolor="#FFFFFF" align="center">
											<img src="{$absoluteResourcesDir}/images/lg_tnt_uk_sml.gif" width="52" height="20"/>
											<br class=""/>
											<font class="smallprint">BOOK COLLECTIONS<br class=""/>ONLINE<br class=""/></font>
											<font class="smallprint">www.tnt.co.uk<br class=""/></font>
											<font class="smallprint">OR CALL CUSTOMER<br class=""/>SERVICES ON<br class=""/>0800 100 600</font>

										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
							</td>

						</tr>
						<tr>
							<td align="center" class="outLineCell" bgcolor="#FDBA8D">
								<font class="header">UK 
        DELIVERY OPTIONS</font>
							</td>
						</tr>
						<tr>
							<td>

								<table class="outLine" width="100%">
									<tr>
										<td>
											<xsl:choose>
 
												<xsl:when test="HEADER/CARRIAGEFORWARD='Y'">
													<font class="header">Service (Carriage Forward):</font>
												</xsl:when>
												<xsl:otherwise>

													<font class="header">Service:&#160;</font>
												</xsl:otherwise>
											</xsl:choose>

											<font class="data">
												<xsl:value-of select="SERVICE"/>
											</font>
										</td>
									</tr>

									<tr>
										<td>
											<font class="data">
												<xsl:if test="OPTION1/text()">
													<xsl:value-of select="OPTION1"/>
												</xsl:if>
												<xsl:if test="OPTION2/text()">
													<br class=""/>
													<xsl:value-of select="OPTION2"/>

												</xsl:if>
												<xsl:if test="OPTION3/text()">
													<br class=""/>
													<xsl:value-of select="OPTION3"/>
												</xsl:if>
												<xsl:if test="OPTION4/text()">
													<br class=""/>
													<xsl:value-of select="OPTION4"/>
												</xsl:if>


												<xsl:if test="../Header/DangerousGoodsOption/Code/text()">
													<br class=""/>
													<xsl:value-of select="../Header/DangerousGoodsOption/Code"/>
													<xsl:value-of select="../Header/DangerousGoodsOption/Name"/>
												</xsl:if>
											</font>
										</td>
									</tr>

								</table>
							</td>
						</tr>
						<tr>
							<td>
								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
							</td>
						</tr>
						<tr>

							<td>
								<table class="outLine" width="100%">
									<tr>
										<td>
											<xsl:choose>
												<xsl:when test="UKDOMESTICITLLOPTION">
													<font class="header">IMPORTANT:</font>
													<font class="data">increased transit liability cover is required</font>

												</xsl:when>
												<xsl:otherwise>
													<font class="data">increased transit liability cover is not required</font>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</table>

							</td>
						</tr>
						<tr>
							<td>
								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
							</td>
						</tr>
						<xsl:choose>

							<xsl:when test="DANGEROUSGOODS = 'Y'">
								<tr>
									<td>
										<table class="outLine" width="100%">
											<tr>
												<td colspan="2">
													<font class="data">DOES THE CONSIGNMENT CONTAIN <font class="header">DANGEROUS GOODS?</font></font>
												</td>

											</tr>
											<tr>
												<td>
													&#160;<img src="{$absoluteResourcesDir}/images/uk_domestic_dangerous_goods_off.gif" width="14" height="13"/>
													<font class="data">&#160;NO&#160;</font>
													<img src="{$absoluteResourcesDir}/images/uk_domestic_dangerous_goods_on.gif" width="14" height="13"/>
													<font class="data">&#160;YES</font>
												</td>

												<td>
													<font class="data">UN NUMBER:&#160;</font>
													<font class="data">
														<xsl:value-of select="UNNUMBER"/>
													</font>
												</td>
											</tr>
											<tr>

												<td colspan="2" align="center">
													<font class="data">DANGEROUS GOODS DELIVERIES ARE NOT GUARANTEED</font>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</xsl:when>

							<xsl:otherwise>
								<tr>
									<td>
										<table class="outLine" width="100%">
											<tr>
												<td colspan="2">
													<font class="data">DOES THE CONSIGNMENT CONTAIN <font class="header">DANGEROUS GOODS?</font></font>
												</td>

											</tr>
											<tr>
												<td>
													&#160;<img src="{$absoluteResourcesDir}/images/uk_domestic_dangerous_goods_on.gif" width="14" height="13"/>
													<font class="data">&#160;NO&#160;</font>
													<img src="{$absoluteResourcesDir}/images/uk_domestic_dangerous_goods_off.gif" width="14" height="13"/>
													<font class="data">&#160;YES</font>
												</td>

												<td>
													<font class="data">UN NUMBER:</font>
												</td>
											</tr>
											<tr>
												<td colspan="2" align="center">
													<font class="data">DANGEROUS GOODS DELIVERIES ARE NOT GUARANTEED</font>
												</td>

											</tr>
										</table>
									</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
						<tr>
							<td>
								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>

							</td>
						</tr>
						<tr>
							<td>
								<table class="outLine" width="100%" border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0">
									<tr>
										<td rowspan="2" width="40%" valign="top">
											<font class="header">Goods Description</font>

										</td>
										<td rowspan="2" width="10%">
											<font class="header">Number of items</font>
										</td>
										<td width="10%" align="center">
											<font class="header">Weight</font>
										</td>
										<td colspan="3" align="center" width="30%">

											<font class="header">Dimensions (cms)</font>
										</td>
									</tr>
									<tr>
										<td align="center">
											<font class="header">Kilos</font>
										</td>
										<td align="center">

											<font class="header">Length</font>
										</td>
										<td align="center">
											<font class="header">Width</font>
										</td>
										<td align="center">
											<font class="header">Height</font>

										</td>
									</tr>
									<xsl:for-each select="PACKAGES/PACKAGE">
										<tr>
											<td>
												<font class="data">
													<xsl:value-of select="GOODSDESC"/>
												</font>
											</td>

											<td>
												<font class="data">
													<xsl:value-of select="ITEMS"/>
												</font>
											</td>
											<td>
												<font class="data">
													<xsl:value-of select="WEIGHT"/>
												</font>

											</td>
											<td>
												<font class="data">
													<xsl:value-of select="LENGTH"/>
												</font>
											</td>
											<td>
												<font class="data">
													<xsl:value-of select="WIDTH"/>

												</font>
											</td>
											<td>
												<font class="data">
													<xsl:value-of select="HEIGHT"/>
												</font>
											</td>
										</tr>
									</xsl:for-each>

									<xsl:choose>
										<xsl:when test="count(PACKAGES/PACKAGE) = 1">
											<xsl:call-template name="blankRow"/>
											<xsl:call-template name="blankRow"/>
										</xsl:when>
										<xsl:when test="count(PACKAGES/PACKAGE) = 2">
											<xsl:call-template name="blankRow"/>
										</xsl:when>

										<xsl:otherwise>
										</xsl:otherwise>
									</xsl:choose>



									<tr>
										<td>
											<font class="header">Total number of items and weight</font>

										</td>
										<td>
											<font class="data">
												<xsl:value-of select="TOTALITEMS"/>
											</font>
										</td>
										<td>
											<font class="data">
												<xsl:value-of select="TOTALWEIGHT"/>

											</font>
										</td>
										<td colspan="3" align="center">
											<font size="-2">Consignment subject to volumetric<br class=""/> measurement</font>
										</td>
									</tr>
								</table>

							</td>
						</tr>
						<tr>
							<td>
								<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
							</td>
						</tr>
						<tr>
							<td height="85" bgcolor="#ffffff" class="outLineCell" style="padding-top: 15px; padding-left: 15px; padding-right: 15px;">

								<!--
								        We display the barcode at half of its original size.
								        This encourages the browser to display it at a smaller
								        size but maintain the accuracy of the image when
								        printing on a printer. There doesn't
								        seem to be a way to tell the browser that this is an
								        image that should not be scaled when printing.
								        
								        Internet Explorer has some weird behaviour when you try
								        to resize to 50% so I've had to specify the exact number
								        of pixels.
								    -->
								<img width="296" src="{$hostName}/barcode/pdf417?BARCODE={PDFBARCODEDATA}"/>
							</td>
						</tr>
						<tr>
							<td>
								<table height="67" class="outLine" width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td>

											<font class="header">RECEIVED BY TNT</font>
										</td>
										<td>
											<font class="header">(Please Print)</font>
										</td>
									</tr>
									<tr>
										<td>

											<img height="30" width="1" src="{$absoluteResourcesDir}/images/1x1.gif"/>
										</td>
									</tr>

									<tr>
										<td>
											<font class="header">Date</font>
											<font class="smallPrint">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;/&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;/&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</font>

											<font class="smallprint">(Day/Month/Year)</font>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<!-- END OF RIGHT HAND COLUMN -->

				</td>
			</tr>
			<tr>
				<td class="outLineCell" colspan="3" bgcolor="#ffffff">
					<font class="smallprint">ALL 
        CONSIGNMENTS ARE CARRIED SUBJECT TO TNT EXPRESS SERVICES CONDITIONS OF 
        CARRIAGE, THE PRINCIPAL CONDITIONS ARE SHOWN BELOW.</font>
				</td>
			</tr>
		</table>

		<p class=""/>
		 
		<table border="0" cellspacing="1" cellpadding="0" width="600">
			<tr>
				<td class="outLineCell">
					<table width="100%" cellspacing="4" cellpadding="1" border="0">
						<tr>
							<td>
								<font class="header">TNT Express Services Principal Conditions 
              of Carriage</font>

							</td>
						</tr>
						<tr>
							<td>
								<font class="data">All goods are carried subject to our Conditions 
              of Carriage which are available on request. It is in your interest 
              to read them as your rights may be affected.</font>
							</td>
						</tr>
						<tr>

							<td>
								<font class="data">Under these conditions our liability is limited 
              to GBP15.00 per Kilo up to 1,000 kilos per consignment and is excluded 
              in certain circumstances. For European Road Service carriage of 
              goods is governed by the Convention on the Contract for the International 
              Carriage of Goods by Road 1956 (CMR). Our liability for loss or 
              damage to your goods is limited to 8.33 SDR&apos;s per kilo or GBP15.00 
              per kilo whichever is the greater.</font>
							</td>
						</tr>
						<tr>
							<td>
								<font class="data">We recommend that you arrange sufficient insurance 
              cover to protect your interest.We can arrange increased transit 
              liability cover on your behalf on request.</font>

							</td>
						</tr>
						<tr>
							<td>
								<font class="data">We are not responsible for loss to you of any 
              profit, loss of customer, or indirect loss of a monetary or consequential 
              nature.</font>
							</td>
						</tr>
						<tr>

							<td>
								<font class="data">Payment for carriage charges is due no later 
              than the 15th day of the month following the month of invoice.</font>
							</td>
						</tr>
						<tr>
							<td>
								<font class="data">Next working days do not include Saturdays 
              or public holidays.Our Saturday delivery service is available on 
              days which are not public holidays.</font>
							</td>

						</tr>
						<tr>
							<td>
								<font class="data">PLEASE NOTE THE FOLLOWING INFORMATION
									<ul style="margin-top: 1px;">
										<li>Please give the items and the consignment note to the collection 
                  driver.</li>
									</ul>
								</font>
							</td>

						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="blankRow">

		<tr>

			<td>&#160;</td>
			<td>&#160;</td>
			<td>&#160;</td>
			<td>&#160;</td>
			<td>&#160;</td>
			<td>&#160;</td>
		</tr>
	</xsl:template>

	<xsl:template name="ukDomesticCollectionAddress">

		<table width="100%" class="outLine" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/COMPANYNAME"/>
					</font>
				</td>

			</tr>
			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/STREETADDRESS1"/>
					</font>
				</td>
			</tr>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/STREETADDRESS2/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/STREETADDRESS2"/>
						</font>
					</td>
				</tr>
			</xsl:if>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/STREETADDRESS3/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/STREETADDRESS3"/>
						</font>
					</td>
				</tr>

			</xsl:if>

			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/CITY"/>
					</font>
				</td>
			</tr>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/PROVINCE/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/PROVINCE"/>
						</font>
					</td>
				</tr>

			</xsl:if>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/POSTCODE/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/POSTCODE"/>
						</font>
					</td>

				</tr>
			</xsl:if>
			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/COUNTRY"/>
					</font>
				</td>
			</tr>

			<tr>
				<td colspan="2">
					<font class="header">CONTACT NAME:</font>&#160;
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/CONTACTNAME"/>
					</font>
				</td>
			</tr>

			<tr>
				<td colspan="2">
					<font class="header">TEL NO:</font>&#160;
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/CONTACTDIALCODE"/>&#160;
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/CONTACTTELEPHONE"/>
					</font>
				</td>

			</tr>
		</table>
	</xsl:template>


	<xsl:template name="ukDomesticSenderAddress">

		<table width="100%" class="outLine" cellpadding="0" cellspacing="0">
			<tr>
				<td>

					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/COMPANYNAME"/>
					</font>
				</td>
			</tr>
			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/STREETADDRESS1"/>

					</font>
				</td>
			</tr>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/STREETADDRESS2/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/COLLECTION/STREETADDRESS2"/>

						</font>
					</td>
				</tr>
			</xsl:if>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/STREETADDRESS3/text()">
				<tr>
					<td>
						<font class="data">

							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/STREETADDRESS3"/>
						</font>
					</td>
				</tr>
			</xsl:if>

			<tr>
				<td>
					<font class="data">

						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/SENDER/COLLECTION/CITY"/>
					</font>
				</td>
			</tr>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/PROVINCE/text()">
				<tr>
					<td>
						<font class="data">

							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/PROVINCE"/>
						</font>
					</td>
				</tr>
			</xsl:if>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/POSTCODE/text()">
				<tr>
					<td>

						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/POSTCODE"/>
						</font>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td>
					<font class="data">

						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/COUNTRY"/>
					</font>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<font class="header">CONTACT NAME:&#160;</font>
					<font class="data">

						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/CONTACTNAME"/>
					</font>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<font class="header">TEL NO:&#160;</font>
					<font class="data">

						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/CONTACTDIALCODE"/>&#160;
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/HEADER/SENDER/CONTACTTELEPHONE"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="UKDomesticDeliveryAddress">

		<table width="100%" class="outLine" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/COMPANYNAME"/>
					</font>
				</td>
			</tr>

			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/STREETADDRESS1"/>
					</font>
				</td>
			</tr>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/STREETADDRESS2/text()">

				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/STREETADDRESS2"/>
						</font>
					</td>
				</tr>
			</xsl:if>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/STREETADDRESS3/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/STREETADDRESS3"/>
						</font>
					</td>
				</tr>
			</xsl:if>

			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/CITY"/>
					</font>
				</td>
			</tr>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/PROVINCE/text()">

				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/PROVINCE"/>
						</font>
					</td>
				</tr>
			</xsl:if>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/POSTCODE/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/POSTCODE"/>
						</font>
					</td>
				</tr>
			</xsl:if>

			<tr>
				<td colspan="2">
					<font class="header">CONTACT NAME:&#160;</font>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/CONTACTNAME"/>
					</font>
				</td>
			</tr>

			<tr>
				<td colspan="2">
					<font class="header">TEL NO:&#160;</font>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/CONTACTDIALCODE"/>&#160;<xsl:value-of select="CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/CONTACTTELEPHONE"/></font>
				</td>
			</tr>
		</table>

	</xsl:template>


	<xsl:template name="UKDomesticReceiverAddress">

		<table width="100%" class="outLine" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/COMPANYNAME"/>

					</font>
				</td>
			</tr>
			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/STREETADDRESS1"/>
					</font>
				</td>

			</tr>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/STREETADDRESS2/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/STREETADDRESS2"/>
						</font>
					</td>

				</tr>
			</xsl:if>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/STREETADDRESS3/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/STREETADDRESS3"/>
						</font>

					</td>
				</tr>
			</xsl:if>

			<tr>
				<td>
					<font class="data">
						<xsl:value-of select="CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/CITY"/>
					</font>

				</td>
			</tr>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/PROVINCE/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/PROVINCE"/>
						</font>

					</td>
				</tr>
			</xsl:if>

			<xsl:if test="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/POSTCODE/text()">
				<tr>
					<td>
						<font class="data">
							<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/POSTCODE"/>

						</font>
					</td>
				</tr>
			</xsl:if>

			<tr>
				<td colspan="2">
					<font class="header">CONTACT NAME:&#160;</font>
					<font class="data">

						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/CONTACTNAME"/>
					</font>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<font class="header">TEL NO:&#160;</font>
					<font class="data">

						<xsl:value-of select="/CONSIGNMENTBATCH/CONSIGNMENT/RECEIVER/CONTACTDIALCODE"/>&#160;<xsl:value-of select="CONSIGNMENTBATCH/CONSIGNMENT/DELIVERY/CONTACTTELEPHONE"/></font>
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="CombinedConnote22" userelativepaths="yes" externalpreview="no" url="UK_Domestic_Shipping_Example&#x2D;result.xml" htmlbaseurl="" outputurl="..\html\ukDOmesticConnote.html" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->