<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="ISO-8859-1"/>
<xsl:template match="/">

	<html>
		<head>
			<title>TNT Manifest</title>
			<script language="JavaScript" type="text/javascript">
			<![CDATA[

			
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
		
		<style>

	
		font.data
		{
		color : black;
		background-color : white;
		font-family : arial, helvetica "sans-serif";
		font-size : 6pt;
	    }
		

		font.title
		{
		color : black;
		background-color : white;
		font-weight : bold;
		font-family : arial, helvetica "sans-serif";
		font-size : 9pt;
		text-decoration:underline;
		}
	
		div
		{
		page-break-after : always;
		}





		</style>
	</head>

	<body>
	<xsl:for-each select="CONSIGNMENTBATCH/CONSIGNMENT">
	<table width="600" border="0" cellspacing="1" cellpadding="0">
	<tr>
		<td width="80"></td>
		<td width="120"></td>
		<td width="150"></td>
		<td width="120"></td>
		<td width="130"></td>
	</tr>
	
	<tr>
		<td colspan="1"><img src="http://iconnection.tnt.com:81/images/logo-small.gif"/></td>
		<td align="center" colspan="3"><font class="title">COLLECTION MANIFEST (DETAIL) - OTHERS (<xsl:if test="PAYMENTIND = 'S'">Sender Pays</xsl:if><xsl:if test="PAYMENTIND = 'R'">Receiver Pays</xsl:if>)-1</font><br/><font class="data">TNT Express<br/>Shipment Date : <xsl:value-of select="HEADER/SHIPMENTDATE"/><br/>Pickup id :&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</font></td>
		<td align="right" ><font class="data">&#160;</font></td>
	</tr>
	
	<tr>
		<td colspan="1"><font class="data">Sender Account<br/>Sender Name<br/>&#38; Address</font></td>
		<td colspan="3"><font class="data">: <xsl:value-of select="HEADER/SENDER/ACCOUNT"/><br/>: <xsl:value-of select="HEADER/SENDER/COMPANYNAME"/><br/>: <xsl:value-of select="HEADER/SENDER/STREETADDRESS1"/>,<xsl:if test="HEADER/SENDER/STREETADDRESS2/text()"><xsl:value-of select="HEADER/SENDER/STREETADDRESS2"/>,</xsl:if><xsl:if test="HEADER/SENDER/STREETADDRESS3/text()"><xsl:value-of select="HEADER/SENDER/STREETADDRESS3"/>,</xsl:if><xsl:if test="HEADER/SENDER/CITY/text()"><xsl:value-of select="HEADER/SENDER/CITY"/>,</xsl:if><xsl:if test="HEADER/SENDER/PROVINCE/text()"><xsl:value-of select="HEADER/SENDER/PROVINCE"/>,</xsl:if><xsl:if test="HEADER/SENDER/POSTCODE/text()"><xsl:value-of select="HEADER/SENDER/POSTCODE"/>,</xsl:if><xsl:value-of select="HEADER/SENDER/COUNTRY"/></font></td>
		<td colspan="1" align="right"><font class="data">Printed on : <script type="text/javascript">
							var d = new Date()
							document.write(d.getDate())
							document.write("/")
							document.write(d.getMonth() + 1)
							document.write("/")
							document.write(d.getFullYear())
							</script></font></td>
	</tr>
	
	<tr>
		<td colspan="5"><hr width="100%" size="1" noshade="true"/></td>
	</tr>

	<tr>
		<td colspan="2" align="center"><script language="JavaScript" type="text/javascript">document.write(barCode('<xsl:value-of select="CONNUMBER"/>'));</script><br/><font class="data">*<xsl:value-of select="CONNUMBER"/>*</font></td>
		<td valign="top"><font class="data">Sending Depot&#160;&#160;&#160;Receiving Depot<br/></font></td>
		<td valign="top" colspan="2"><font class="data"><u>Special Instructions</u><xsl:if test="DELIVERYINST/text()"><br/><xsl:value-of select="DELIVERYINST"/></xsl:if><br/><xsl:if test="PAYMENTIND = 'S'">Sender Pays</xsl:if><xsl:if test="PAYMENTIND = 'R'">Receiver Pays</xsl:if></font></td>
	</tr>

	<tr>
		<td colspan="1"><font class="data">Sender Contact</font></td>
		<td colspan="4"><font class="data">: <xsl:value-of select="HEADER/SENDER/CONTACTNAME"/>
		&#160;&#160;Tel : <xsl:value-of select="HEADER/SENDER/CONTACTDIALCODE"/>&#160;<xsl:value-of select="HEADER/SENDER/CONTACTTELEPHONE"/>
		&#160;&#160;Sender Ref : <xsl:value-of select="CUSTOMERREF"/>
		&#160;&#160;Receiver Vat Nr : <xsl:value-of select="RECEIVER/VAT"/>
		&#160;&#160;Receiver Acc Number : <xsl:value-of select="RECEIVER/ACCOUNT"/></font></td>
	</tr>

	<tr>
		<td valign="top" colspan="1"><font class="data">Receiver Name<br/>&#38; Address<br/>Receiver Tel<br/>Collection<br/>&#38; Address<br/>Delivery<br/>&#38; Address</font></td>
		<td valign="top" colspan="3"><font class="data">: <xsl:value-of select="RECEIVER/COMPANYNAME"/>,<xsl:value-of select="RECEIVER/STREETADDRESS1"/>,<xsl:if test="RECEIVER/STREETADDRESS2/text()"><xsl:value-of select="RECEIVER/STREETADDRESS2"/>,</xsl:if><xsl:if test="RECEIVER/STREETADDRESS3/text()"><xsl:value-of select="RECEIVER/STREETADDRESS3"/></xsl:if>&#160;&#160;&#160;Receiver Contact : <xsl:value-of select="RECEIVER/CONTACTNAME"/><br/>: <xsl:if test="RECEIVER/CITY/text()"><xsl:value-of select="RECEIVER/CITY"/>,</xsl:if><xsl:if test="RECEIVER/PROVINCE/text()"><xsl:value-of select="RECEIVER/PROVINCE"/>,</xsl:if><xsl:if test="RECEIVER/POSTCODE/text()"><xsl:value-of select="RECEIVER/POSTCODE"/>,</xsl:if><xsl:value-of select="RECEIVER/COUNTRY"/><br/>: <xsl:if test="RECEIVER/CONTACTTELEPHONE/text()"><xsl:value-of select="RECEIVER/CONTACTDIALCODE"/>&#160;<xsl:value-of select="RECEIVER/CONTACTTELEPHONE"/></xsl:if><br/>: <xsl:if test="HEADER/COLLECTION/COMPANYNAME/text()"><xsl:value-of select="HEADER/COLLECTION/COMPANYNAME"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/STREETADDRESS1/text()"><xsl:value-of select="HEADER/COLLECTION/STREETADDRESS1"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/STREETADDRESS2/text()"><xsl:value-of select="HEADER/COLLECTION/STREETADDRESS2"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/STREETADDRESS3/text()"><xsl:value-of select="HEADER/COLLECTION/STREETADDRESS3"/></xsl:if><br/>: <xsl:if test="HEADER/COLLECTION/CITY/text()"><xsl:value-of select="HEADER/COLLECTION/CITY"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/PROVINCE/text()"><xsl:value-of select="HEADER/COLLECTION/PROVINCE"/>,</xsl:if><xsl:if test="HEADER/COLLECTION/POSTCODE/text()"><xsl:value-of select="HEADER/COLLECTION/POSTCODE"/>,</xsl:if><xsl:value-of select="HEADER/COLLECTION/COUNTRY"/><br/>: <xsl:if test="DELIVERY/COMPANYNAME/text()"><xsl:value-of select="DELIVERY/COMPANYNAME"/>,</xsl:if><xsl:if test="DELIVERY/STREETADDRESS1/text()"><xsl:value-of select="DELIVERY/STREETADDRESS1"/>,</xsl:if><xsl:if test="DELIVERY/STREETADDRESS2/text()"><xsl:value-of select="DELIVERY/STREETADDRESS2"/>,</xsl:if><xsl:if test="DELIVERY/STREETADDRESS3/text()"><xsl:value-of select="DELIVERY/STREETADDRESS3"/></xsl:if><br/>: <xsl:if test="DELIVERY/CITY/text()"><xsl:value-of select="DELIVERY/CITY"/>,</xsl:if><xsl:if test="DELIVERY/PROVINCE/text()"><xsl:value-of select="DELIVERY/PROVINCE"/>,</xsl:if><xsl:if test="DELIVERY/POSTCODE/text()"><xsl:value-of select="DELIVERY/POSTCODE"/>,</xsl:if><xsl:value-of select="DELIVERY/COUNTRY"/></font></td>
		<td valign="top" colspan="1"><font class="data">Serv : <xsl:value-of select="SERVICE"/><br/>Opts : <xsl:value-of select="OPTION1"/><xsl:if test="OPTION2/text()"><br/><xsl:value-of select="OPTION2"/></xsl:if><xsl:if test="OPTION3/text()"><br/><xsl:value-of select="OPTION3"/></xsl:if><xsl:if test="OPTION4/text()"><br/><xsl:value-of select="OPTION4"/></xsl:if><xsl:if test="OPTION5/text()"><br/><xsl:value-of select="OPTION5"/></xsl:if></font></td>
	</tr>

	<tr>
		<td colspan="1"><font class="data">No Pieces : <xsl:value-of select="TOTALITEMS"/></font></td>
		<td colspan="1"><font class="data">Weight : <xsl:value-of select="TOTALWEIGHT"/>&#160;<xsl:value-of select="TOTALWEIGHT/@units"/></font></td>
		<td colspan="1"><font class="data">Insurance Value : <xsl:value-of select="INSURANCEVALUE"/>&#160;<xsl:value-of select="INSURANCECURRENCY"/></font></td>
		<td colspan="2"><font class="data">Invoice Value : <xsl:value-of select="GOODSVALUE"/>&#160;<xsl:value-of select="CURRENCY"/></font></td>
		<td></td>
	</tr>



	<tr>
		<td colspan="2" valign="bottom"><font class="data">Description (including packing and marks)</font></td>
		<td colspan="2" align="center" valign="bottom"><font class="data">Dimensions (L x W x H)</font></td>
		<td colspan="1" align="center" valign="top"><font class="data">Total Consignment Volume<br/><xsl:value-of select="TOTALVOLUME"/><xsl:value-of select="PACKAGE/VOLUME/@units"/></font></td>
	</tr>

	<xsl:for-each select="PACKAGE/ARTICLE">
	<tr>
		<td colspan="2"><font class="data"><xsl:value-of select="INVOICEDESC"/></font></td>
		<td colspan="2" align="center" valign="top"><font class="data"><xsl:value-of select="../LENGTH"/><xsl:value-of select="../LENGTH/@units"/>&#160;x&#160;<xsl:value-of select="../WIDTH"/><xsl:value-of select="../WIDTH/@units"/>&#160;x&#160;<xsl:value-of select="../HEIGHT"/><xsl:value-of select="../HEIGHT/@units"/></font></td>
		<td colspan="1" align="center" valign="top"><font class="data">&#160;</font></td>
	</tr>
	</xsl:for-each>

		

	<tr>
		<td colspan="5"><hr width="100%" size="1" noshade="true"/></td>
	</tr>



	
	</table>

	<xsl:choose>
				<xsl:when test="HEADER/@last ='false'">
						<div>
							<font size="1" color="#5FFFFF">.</font>
						</div>
				</xsl:when>
				<xsl:otherwise>
	
				</xsl:otherwise>
				</xsl:choose>
	</xsl:for-each>
				
	</body>
</html>
				
			
	
</xsl:template>

</xsl:stylesheet>