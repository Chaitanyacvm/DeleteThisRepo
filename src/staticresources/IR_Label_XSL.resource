<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="ISO-8859-1"/>

		<xsl:variable name="absoluteResourcesDir" select="'http://iconnection.tnt.com:81/Shipper/NewStyleSheets'"/>
		<xsl:variable name="hostName" select="'https://my.tnt.com/'"/>
		
		<xsl:variable name="UKDomSysId" select="'6'"/>

	<xsl:template match="/">


		<html>

			<head>
				<title>TNT Label</title>

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
				
					function barCode(barString) 
						{
							var myCode = new Array();
							var grow = "";
							for (var i = 0; i != barString.length; i++) 
							{
								var myChar = barString.charAt(i);
								if (myChar == "*") 
								{
									myCode[i] = "bc_star.gif";
								} 
								else 
								{
									myCode[i] = "bc_" + myChar + ".gif";
								}
							}

							for (var i=0; i != myCode.length; i++)
							{
								grow = grow + '<img width="14" height="60" src="http://iconnection.tnt.com:81/Shipper/barcode/' + myCode[i] + '" />';
							}

							return grow;
	
						}
					]]>
				</script>
				<style><![CDATA[
							font.header { color : black; background-color : white; font-weight : bold; font-family : arial, helvetica "sans-serif"; font-size : 8pt; } 


							 font.data { color : black; background-color : white; font-family : arial , "sans-serif"; font-size : 8pt; }

							 font.smallprint { color : black; background-color : white; font-family : arial, "sans-serif"; font-size : 6pt; }
 
							 div { page-break-after : always; }

							.data { }

							.dataBold { font-weight: bold; }

							.label { }

							 .deliveryDepot {  font-size: 96px;  }

							 .deliveryPostcode { font-size: xx-large; font-weight: bold; }

							 .normalService { font-size: x-large; }

								.premiumService { font-size: xx-large; font-weight: bold; }
					
					.tntTelephone { font-size: small; }

					.label {}


					]]>
				</style>
			</head>
			<body>

				<xsl:for-each select="CONSIGNMENTBATCH/PACKAGE">
				 
				<xsl:choose>
					<xsl:when test="CONSIGNMENT/@marketType='DOMESTIC'">
						<xsl:choose>
							<xsl:when test="CONSIGNMENT/@originCountry='GB'">
								<xsl:call-template name="ukDomesticLabel"/>
							</xsl:when>
							<xsl:otherwise>

								<xsl:call-template name="internationalLabel"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="internationalLabel"/>
					</xsl:otherwise>
				</xsl:choose>
				 
				</xsl:for-each>

			</body>
		</html>
	</xsl:template>

	<xsl:template name="defaultlLabel">
		<xsl:call-template name="internationalLabel"/>
	</xsl:template>


	<xsl:template name="ukDomesticLabel">

		<xsl:variable name="collection-depot" select="format-number(HEADER/COLLECTIONDEPOTNAME/@depotCode, '000')"/>
		<xsl:variable name="delivery-depot" select="format-number(CONSIGNMENT/DELIVERYDEPOT, '000')"/>

		<script type="text/Javascript">includePageBreak();</script>

		<table height="98%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<table width="550" border="1" bordercolor="#000000" cellspacing="0" cellpadding="0">

						<tr>
							<xsl:choose>
								<xsl:when test="CONSIGNMENT/SERVICE/@Premium='Y'">
									<td width="50%" align="center" class="premiumService">
										<xsl:value-of select="CONSIGNMENT/SERVICESHORTNAME"/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td width="50%" align="center" class="normalService">

										<xsl:value-of select="CONSIGNMENT/SERVICESHORTNAME"/>
									</td>
								</xsl:otherwise>
							</xsl:choose>




							<td width="50%">
								<table width="100%" cellpadding="2" cellspacing="0">
									<tr>

										<td nowrap="nowrap" class="tntTelephone" align="center">Telephone<br class=""/> 01827 303030</td>
										<td width="30%">
											<img src="{$absoluteResourcesDir}/images/lg_tnt.gif" width="167" height="83" border="0"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>

						<tr>
							<td valign="middle">
								<table width="100%" border="0" cellspacing="0" cellpadding="1">
									<tr>
										<td rowspan="6" width="1%">
											<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
										</td>
										<td class="label" width="45%">Coll. Depot:</td>

										<td width="64%">
											<span class="data">
												<xsl:value-of select="HEADER/COLLECTIONDEPOTNAME"/>
											</span>&#160;&#160;
											<span class="dataBold">
												<xsl:value-of select="HEADER/COLLECTIONDEPOTNAME/@depotCode"/>
											</span>
										</td>
									</tr>

									<tr>
										<td class="label">Sender A/c:</td>
										<td class="dataBold">
											<xsl:value-of select="format-number(HEADER/SENDER/ACCOUNT , '0000000000')"/>
										</td>
									</tr>
									<tr>
										<td class="label">Cons. No.</td>

										<td class="dataBold">
											<xsl:value-of select="substring(CONSIGNMENT/CONNUMBER, 1, 8)"/>
											<xsl:value-of select="substring(CONSIGNMENT/CONNUMBER, 9, 1)"/>
										</td>
									</tr>
									<tr>
										<td class="label">Weight (kg):</td>
										<td class="data">

											<xsl:value-of select="WEIGHT"/>
										</td>
									</tr>
									<tr>
										<td>Item No.:</td>
										<td class="dataBold">
											<xsl:value-of select="format-number(PACKAGEINDEX,'000')"/>of <xsl:value-of select="format-number(PACKAGEMAX,'000')"/></td>
									</tr>

									<tr>
										<td class="label">Coll. Date :</td>
										<td class="data">
											<xsl:value-of select="HEADER/SHIPMENTDATE"/>
										</td>
									</tr>
								</table>
							</td>

							<td class="deliveryDepot" align="center" valign="middle">
								<xsl:value-of select="CONSIGNMENT/DELIVERYDEPOTNAME/@depotCode"/>
							</td>
						</tr>
						<tr>
							<td rowspan="3" valign="top">
								<table width="100%" border="0" cellspacing="1" cellpadding="1">
									<tr>
										<td rowspan="10" width="1%">

											<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
										</td>
										<td width="39%" class="label">Deliver to:</td>
									</tr>
									<xsl:choose>

										<xsl:when test="CONSIGNMENT/DELIVERY/COMPANYNAME/text()">
											<tr>
												<td class="dataBold">

													<xsl:value-of select="CONSIGNMENT/DELIVERY/CONTACTNAME"/>
												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/DELIVERY/COMPANYNAME"/>
												</td>
											</tr>
											<tr>

												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/DELIVERY/STREETADDRESS1"/>
												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/DELIVERY/STREETADDRESS2"/>
												</td>
											</tr>

											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/DELIVERY/STREETADDRESS3"/>
												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/DELIVERY/CITY"/>
												</td>

											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/DELIVERY/PROVINCE"/>
												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/DELIVERY/POSTCODE"/>

												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/DELIVERY/COUNTRY"/>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>

											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/RECEIVER/CONTACTNAME"/>
												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/RECEIVER/COMPANYNAME"/>
												</td>

											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/RECEIVER/STREETADDRESS1"/>
												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/RECEIVER/STREETADDRESS2"/>

												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/RECEIVER/STREETADDRESS3"/>
												</td>
											</tr>
											<tr>
												<td class="dataBold">

													<xsl:value-of select="CONSIGNMENT/RECEIVER/CITY"/>
												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/RECEIVER/PROVINCE"/>
												</td>
											</tr>
											<tr>

												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/RECEIVER/POSTCODE"/>
												</td>
											</tr>
											<tr>
												<td class="dataBold">
													<xsl:value-of select="CONSIGNMENT/RECEIVER/COUNTRY"/>
												</td>
											</tr>

										</xsl:otherwise>
									</xsl:choose>
									<tr>
										<td height="10">
										</td>
									</tr>
								</table>
							</td>
							<td valign="top">

								<table width="100%" border="0" cellspacing="0" cellpadding="1">
									<tr>
										<td rowspan="2" width="1%">
											<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
										</td>
										<td class="label">Special Instructions:</td>
									</tr>
									<tr>

										<td class="dataBold">
											<xsl:value-of select="substring(CONSIGNMENT/DELIVERYINST, 1, 25)"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top">

								<table width="100%" border="0" cellspacing="0" cellpadding="1">
									<tr>
										<td rowspan="2" width="1%">
											<img src="{$absoluteResourcesDir}/images/1x1.gif" width="1" height="1"/>
										</td>
										<td class="label">Customer Reference:</td>
									</tr>
									<tr>

										<td class="dataBold">
											<xsl:value-of select="substring(CONSIGNMENT/CUSTOMERREF, 1, 15)"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<xsl:choose>

							<xsl:when test="CONSIGNMENT/DELIVERY/COMPANYNAME/text()">
								<tr>
									<td align="center" class="deliveryPostcode">
										<xsl:value-of select="CONSIGNMENT/DELIVERY/POSTCODE"/>
									</td>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<tr>

									<td align="center" class="deliveryPostcode">
										<xsl:value-of select="CONSIGNMENT/RECEIVER/POSTCODE"/>
									</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
						<tr>
							<td colspan="2" align="center" height="150" valign="middle">
							    <xsl:value-of select="$UKDomSysId"/>

								<xsl:value-of select="HEADER/COLLECTIONDEPOTNAME/@depotCode"/>
								<xsl:value-of select="format-number(HEADER/SENDER/ACCOUNT, '0000000000')"/>
								<xsl:value-of select="substring(CONSIGNMENT/CONNUMBER, 1, 8)"/>
								<xsl:value-of select="format-number(PACKAGEINDEX, '000')"/>
								<xsl:value-of select="CONSIGNMENT/DELIVERYDEPOTNAME/@depotCode"/>
								<br/>
								<img src="{$hostName}/barcode/barbecue?data={$UKDomSysId}{HEADER/COLLECTIONDEPOTNAME/@depotCode}{format-number(HEADER/SENDER/ACCOUNT, '0000000000')}{substring(CONSIGNMENT/CONNUMBER, 1, 8)}{format-number(CONSIGNMENTBATCH/PACKAGE/PACKAGEINDEX, '000')}{CONSIGNMENT/DELIVERYDEPOTNAME/@depotCode}&amp;type=UCC128&amp;appid=6&amp;height=105"/>
							</td>
						</tr>

					</table>
				</td>
			</tr>
			<tr height="75%" valign="top" align="center">
				<td valign="center">
					<font size="20">
						<b>Address Label</b>
					</font>

					<br/>
					<br/>
					<br/>
					<font class="data">Please fold this page  and attach it to your parcel</font>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="internationalLabel">
		<!--start of main table -->
		<table cellSpacing="0" width="600" border="1" height="500" cellPadding="3">
			<xsl:choose>
				<xsl:when test="HEADER/COLLECTION/COMPANYNAME/text()">
					<tr>
						<td width="300" valign="top">
							<font class="header">Account :</font>

							<font class="data">
								<xsl:value-of select="HEADER/SENDER/ACCOUNT"/>
							</font>
							<br/>
							<font class="header">Sender</font>
							<br/>
							<font class="data">
								<xsl:value-of select="HEADER/COLLECTION/COMPANYNAME"/>

								<br/>
								<xsl:value-of select="HEADER/COLLECTION/STREETADDRESS1"/>
								<br/>
								<xsl:if test="HEADER/COLLECTION/STREETADDRESS2/text()">
									<xsl:value-of select="HEADER/COLLECTION/STREETADDRESS2"/>
									<br/>
								</xsl:if>
								<xsl:if test="HEADER/COLLECTION/STREETADDRESS3/text()">
									<xsl:value-of select="HEADER/COLLECTION/STREETADDRESS3"/>

									<br/>
								</xsl:if>
								<xsl:value-of select="HEADER/COLLECTION/CITY"/>
								<br/>
								<xsl:if test="HEADER/COLLECTION/PROVINCE/text()">
									<xsl:value-of select="HEADER/COLLECTION/PROVINCE"/>
									<br/>
								</xsl:if>
								<xsl:if test="HEADER/COLLECTION/POSTCODE/text()">

									<xsl:value-of select="HEADER/COLLECTION/POSTCODE"/>
									<br/>
								</xsl:if>
								<xsl:value-of select="HEADER/COLLECTION/COUNTRY"/>
							</font>
							<br/>
							<font class="header">Contact :</font>
							<font class="data">

								<xsl:value-of select="HEADER/COLLECTION/CONTACTNAME"/>
							</font>
							<br/>
							<font class="header">Tel :</font>
							<font class="data">
								<xsl:value-of select="HEADER/COLLECTION/CONTACTDIALCODE"/>
								<xsl:value-of select="HEADER/COLLECTION/CONTACTTELEPHONE"/>
							</font>

						</td>
						<td align="center" width="300" colspan="2">
							<img src="http://iconnection.tnt.com:81/images/logo.gif"/>
							<br/>
							<br/>
							<script language="JavaScript" type="text/javascript">document.write(barCode(&apos;*<xsl:value-of select="/CONSIGNMENTBATCH/PACKAGE/CONSIGNMENT/CONNUMBER"/>*&apos;));</script>
							<br/>

							<font class="header">*<xsl:value-of select="/CONSIGNMENTBATCH/PACKAGE/CONSIGNMENT/CONNUMBER"/>*</font>
							<br/>
							<br/>
							<font class="header">Customer Reference :</font>
							<font class="data">
								<xsl:value-of select="CONSIGNMENT/CUSTOMERREF"/>
							</font>

						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td width="300" vAlign="top">
							<font class="header">Account :</font>
							<font class="data">

								<xsl:value-of select="HEADER/SENDER/ACCOUNT"/>
							</font>
							<br/>
							<font class="header">Sender</font>
							<br/>
							<font class="data">
								<xsl:value-of select="HEADER/SENDER/COMPANYNAME"/>
								<br/>

								<xsl:value-of select="HEADER/SENDER/STREETADDRESS1"/>
								<br/>
								<xsl:if test="HEADER/SENDER/STREETADDRESS2/text()">
									<xsl:value-of select="HEADER/SENDER/STREETADDRESS2"/>
									<br/>
								</xsl:if>
								<xsl:if test="HEADER/SENDER/STREETADDRESS3/text()">
									<xsl:value-of select="HEADER/SENDER/STREETADDRESS3"/>
									<br/>

								</xsl:if>
								<xsl:value-of select="HEADER/SENDER/CITY"/>
								<br/>
								<xsl:if test="HEADER/SENDER/PROVINCE/text()">
									<xsl:value-of select="HEADER/SENDER/PROVINCE"/>
									<br/>
								</xsl:if>
								<xsl:if test="HEADER/SENDER/POSTCODE/text()">
									<xsl:value-of select="HEADER/SENDER/POSTCODE"/>

									<br/>
								</xsl:if>
								<xsl:value-of select="HEADER/SENDER/COUNTRY"/>
							</font>
							<br/>
							<font class="header">Contact :</font>
							<font class="data">
								<xsl:value-of select="HEADER/SENDER/CONTACTNAME"/>

							</font>
							<br/>
							<font class="header">Tel :</font>
							<font class="data">
								<xsl:value-of select="HEADER/SENDER/CONTACTDIALCODE"/>&#160;
								<xsl:value-of select="HEADER/SENDER/CONTACTTELEPHONE"/>
							</font>
						</td>

						<td align="center" width="300" colSpan="2">
							<img src="http://iconnection.tnt.com:81/images/logo.gif"/>
							<br/>
							<br/>
							<script language="JavaScript" type="text/javascript">document.write(barCode(&apos;*<xsl:value-of select="CONSIGNMENT/CONNUMBER"/>*&apos;));</script>
							<br/>
							<font class="header">*
								<xsl:value-of select="CONSIGNMENT/CONNUMBER"/>*</font>

							<br/>
							<br/>
							<font class="header">Customer Reference :</font>
							<font class="data">
								<xsl:value-of select="CONSIGNMENT/CUSTOMERREF"/>
							</font>
						</td>
					</tr>

				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="CONSIGNMENT/DELIVERY/COMPANYNAME/text()">
					<tr>
						<td valign="top">
							<font class="header">Delivery Address</font>
							<br/>

							<font class="data">
								<xsl:value-of select="CONSIGNMENT/DELIVERY/COMPANYNAME"/>
								<br/>
								<xsl:value-of select="CONSIGNMENT/DELIVERY/STREETADDRESS1"/>
								<br/>
								<xsl:if test="CONSIGNMENT/DELIVERY/STREETADDRESS2/text()">
									<xsl:value-of select="CONSIGNMENT/DELIVERY/STREETADDRESS2"/>
									<br/>
								</xsl:if>

								<xsl:if test="CONSIGNMENT/DELIVERY/STREETADDRESS3/text()">
									<xsl:value-of select="CONSIGNMENT/DELIVERY/STREETADDRESS3"/>
									<br/>
								</xsl:if>
								<xsl:value-of select="CONSIGNMENT/DELIVERY/CITY"/>
								<br/>
								<xsl:if test="CONSIGNMENT/DELIVERY/PROVINCE/text()">
									<xsl:value-of select="CONSIGNMENT/DELIVERY/PROVINCE"/>
									<br/>

								</xsl:if>
								<xsl:if test="CONSIGNMENT/DELIVERY/POSTCODE/text()">
									<xsl:value-of select="CONSIGNMENT/DELIVERY/POSTCODE"/>
									<br/>
								</xsl:if>
								<xsl:value-of select="CONSIGNMENT/DELIVERY/COUNTRY"/>
							</font>
							<br/>
							<font class="header">Contact :</font>

							<font class="data">
								<xsl:value-of select="CONSIGNMENT/DELIVERY/CONTACTNAME"/>
							</font>
							<br/>
							<font class="header">Tel :</font>
							<font class="data">
								<xsl:value-of select="CONSIGNMENT/DELIVERY/CONTACTDIALCODE"/>
								<xsl:value-of select="CONSIGNMENT/DELIVERY/CONTACTTELEPHONE"/>

							</font>
						</td>

						<td colspan="2" valign="top">
							<font class="header">Shipment Date :</font>
							<font class="data">
								<xsl:value-of select="HEADER/SHIPMENTDATE"/>
							</font>
							<br/>

							<font class="header">Description of Goods</font>
							<br/>
							<font class="data">
								<xsl:value-of select="CONSIGNMENT/GOODSDESC1"/>
								<br/>
								<xsl:value-of select="CONSIGNMENT/GOODSDESC2"/>
								<br/>
								<xsl:value-of select="CONSIGNMENT/GOODSDESC3"/>

							</font>
							<font class="header">
								<br/>Dimensions :</font>
							<xsl:if test="CONSIGNMENT/CONSIGNMENTTYPE = 'N'">
								<font class="data">
									<xsl:value-of select="LENGTH"/>
									<xsl:value-of select="LENGTH/@units"/>x <xsl:value-of select="WIDTH"/> <xsl:value-of select="WIDTH/@units"/> x <xsl:value-of select="HEIGHT"/><xsl:value-of select="HEIGHT/@units"/></font>

							</xsl:if>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td vAlign="top">
							<font class="header">Delivery Address</font>

							<br/>
							<font class="data">
								<xsl:value-of select="CONSIGNMENT/RECEIVER/COMPANYNAME"/>
								<br/>
								<xsl:value-of select="CONSIGNMENT/RECEIVER/STREETADDRESS1"/>
								<br/>
								<xsl:if test="CONSIGNMENT/RECEIVER/STREETADDRESS2/text()">
									<xsl:value-of select="CONSIGNMENT/RECEIVER/STREETADDRESS2"/>
									<br/>

								</xsl:if>
								<xsl:if test="CONSIGNMENT/RECEIVER/STREETADDRESS3/text()">
									<xsl:value-of select="CONSIGNMENT/RECEIVER/STREETADDRESS3"/>
									<br/>
								</xsl:if>
								<xsl:value-of select="CONSIGNMENT/RECEIVER/CITY"/>
								<br/>
								<xsl:if test="CONSIGNMENT/RECEIVER/PROVINCE/text()">
									<xsl:value-of select="CONSIGNMENT/RECEIVER/PROVINCE"/>

									<br/>
								</xsl:if>
								<xsl:if test="CONSIGNMENT/RECEIVER/POSTCODE/text()">
									<xsl:value-of select="CONSIGNMENT/RECEIVER/POSTCODE"/>
									<br/>
								</xsl:if>
								<xsl:value-of select="CONSIGNMENT/RECEIVER/COUNTRY"/>
							</font>
							<br/>

							<font class="header">Contact :</font>
							<font class="data">
								<xsl:value-of select="CONSIGNMENT/RECEIVER/CONTACTNAME"/>
							</font>
							<br/>
							<font class="header">Tel :</font>
							<font class="data">
								<xsl:value-of select="CONSIGNMENT/RECEIVER/CONTACTDIALCODE"/>&#160;

								<xsl:value-of select="CONSIGNMENT/RECEIVER/CONTACTTELEPHONE"/>
							</font>
						</td>
						<td vAlign="top" colSpan="2">
							<font class="header">Shipment Date :</font>
							<font class="data">
								<xsl:value-of select="HEADER/SHIPMENTDATE"/>
							</font>

							<br/>
							<font class="header">Description of Goods</font>
							<br/>
							<font class="data">
								<xsl:value-of select="CONSIGNMENT/GOODSDESC1"/>
								<br/>
								<xsl:value-of select="CONSIGNMENT/GOODSDESC2"/>
								<br/>

								<xsl:value-of select="CONSIGNMENT/GOODSDESC3"/>
								<font class="header">Dimensions :</font>
								<xsl:if test="CONSIGNMENT/CONSIGNMENTTYPE = 'N'">
									<font class="data">&#160;
										<xsl:value-of select="LENGTH"/>&#160;
										<xsl:value-of select="LENGTH/@units"/>&#160;x&#160;
										<xsl:value-of select="WIDTH"/>&#160;
										<xsl:value-of select="WIDTH/@units"/>&#160;x&#160;

										<xsl:value-of select="HEIGHT"/>
										<xsl:value-of select="HEIGHT/@units"/>&#160;</font>
								</xsl:if>
							</font>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
			<tr>

				<td colSpan="3">
					<font class="header">Special Delivery Instructions :</font>
					<font class="data">
						<xsl:value-of select="CONSIGNMENT/DELIVERYINST"/>
					</font>
				</td>
			</tr>
			<tr>

				<td>
					<font class="header">Service and Options</font>
					<br/>
					<font class="data">
						<xsl:value-of select="CONSIGNMENT/SERVICE"/>
						<br/>
						<xsl:value-of select="CONSIGNMENT/OPTION1"/>
						<br/>

						<xsl:value-of select="CONSIGNMENT/OPTION2"/>
						<br/>
						<xsl:value-of select="CONSIGNMENT/OPTION3"/>
						<br/>
						<xsl:value-of select="CONSIGNMENT/OPTION4"/>
						<br/>
						<xsl:value-of select="CONSIGNMENT/OPTION5"/>
					</font>
				</td>

				<td align="center" width="70">
					<font class="header">No of Items</font>
					<br/>
					<font class="data">
						<xsl:value-of select="PACKAGEINDEX"/>of
						<xsl:value-of select="PACKAGEMAX"/>
					</font>
					<br/>
					<br/>

					<font class="header">Item Weight
						<br/>
					</font>
					<font class="data">
						<xsl:value-of select="WEIGHT"/>&#160;
						<xsl:value-of select="WEIGHT/@units"/>
					</font>
					<br/>
				</td>

				<td>
					<font class="smallprint">TNT'S LIABILITY FOR LOSS, DAMAGE AND DELAY IS LIMITED BY THE CMR CONVENTION OR THE WARSAW CONVENTION WHICHEVER IS APPLICABLE. THE SENDER AGREES THAT THE GENERAL CONDITIONS, ACCESSIBLE AT HTTP://ICONNECTION.TNT.COM:81/TERMSANDCONDITIONS.HTML, ARE ACCEPTABLE AND GOVERN THIS CONTRACT. IF NO SERVICES OR BILLING OPTIONS ARE SELECTED THE FASTEST AVAILABLE SERVICE WILL BE CHARGED TO THE SENDER.</font>
				</td>
			</tr>
		</table>
		<xsl:choose>
			<xsl:when test="HEADER/@last ='false'">
				<div>

					<font size="1" color="#5fffff">.</font>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="PACKAGEMAX != PACKAGEINDEX">
					<br/>
					<br/>
					<DIV>

						<FONT SIZE="1" COLOR="#5FFFFF">.</FONT>
					</DIV>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="no" name="UKDomesticLabel" userelativepaths="yes" externalpreview="no" url="..\label.xml" htmlbaseurl="" outputurl="newCombinedLabel.html" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="yes" name="CombinedLabel22" userelativepaths="yes" externalpreview="no" url="UKDOMESTIC&#x2D;LABEL.xml" htmlbaseurl="" outputurl="..\html\newCombinedLabel.html" processortype="msxml4" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->