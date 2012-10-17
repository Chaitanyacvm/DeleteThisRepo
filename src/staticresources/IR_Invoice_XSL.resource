<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="ISO-8859-1"/>
<xsl:template match="/">
	<html>
	<head>
	<title>TNT Commercial Invoice</title>
	<style>
		div
		{
		page-break-after : always;
		}

		font.header
		{
		color : black;
		background-color : white;
		font-weight : bold;
		font-family : arial, helvetica "sans-serif";
		font-size : 10pt;
	    }


		font.data
		{
		color : black;
		background-color : white;
		font-family : arial , "sans-serif";
		font-size : 8pt;
		}
		</style>
		</head>
		<body>
			<xsl:choose>
			<xsl:when test="CONSIGNMENTBATCH/CONSIGNMENT/@copies">
				<xsl:call-template name="Invoice">
					<xsl:with-param name="Copies" select="/CONSIGNMENTBATCH/CONSIGNMENT/@copies"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:call-template name="Invoice">
					<xsl:with-param name="Copies" select="'1'"/>
				</xsl:call-template>
			</xsl:otherwise>
			</xsl:choose>
			
			</body>
			</html>

			
		</xsl:template>
		
		<xsl:template name="Invoice">
			<xsl:param name="Copies"/>
			<xsl:param name="Copy" select="1"/>
			

			<xsl:if test="$Copy &lt;= $Copies">
		

		<xsl:for-each select="CONSIGNMENTBATCH/CONSIGNMENT">




		<table width="600" cellpadding="3" cellspacing="0" border="1">
			<tr>
				
			<td width="300" valign="top"><font class="header">SENDER (Seller/Exporter)</font><br/><font class="data"><xsl:value-of select="HEADER/SENDER/COMPANYNAME"/><br/><xsl:value-of select="HEADER/SENDER/STREETADDRESS1"/><br/><xsl:if test="HEADER/SENDER/STREETADDRESS2/text()"><xsl:value-of select="HEADER/SENDER/STREETADDRESS2"/><br/></xsl:if><xsl:if test="HEADER/SENDER/STREETADDRESS3/text()"><xsl:value-of select="HEADER/SENDER/STREETADDRESS3"/><br/></xsl:if><xsl:value-of select="HEADER/SENDER/CITY"/><br/><xsl:if test="HEADER/SENDER/PROVINCE/text()"><xsl:value-of select="HEADER/SENDER/PROVINCE"/><br/></xsl:if><xsl:if test="HEADER/SENDER/POSTCODE/text()"><xsl:value-of select="HEADER/SENDER/POSTCODE"/><br/></xsl:if><xsl:value-of select="HEADER/SENDER/COUNTRY"/><br/><xsl:value-of select="HEADER/SENDER/CONTACTNAME"/><br/><xsl:value-of select="HEADER/SENDER/CONTACTDIALCODE"/>&#160;<xsl:value-of select="HEADER/SENDER/CONTACTTELEPHONE"/></font></td>
			
			<td width="300">
					<table width="300" cellpadding="3" cellspacing="0" border="2">
						<tr>
							<td align="center" colspan="2"><font size="20"><b>Invoice</b></font></td>
						</tr>
						<tr>
							<td><font class="header">Invoice Number : </font></td>
							<td align="center"><font class="data">&#160;</font></td>
						</tr>
						<tr>
							<td><font class="header">Date : </font></td>
							<td align="center"><font class="data"><script type="text/javascript">
							var d = new Date()
							document.write(d.getDate())
							document.write("/")
							document.write(d.getMonth() + 1)
							document.write("/")
							document.write(d.getFullYear())
							</script></font></td>
						</tr>
						<tr>
							<td><font class="header">Consignment Note No : </font></td>
							<td align="center"><font class="data"><xsl:value-of select="CONNUMBER"/></font></td>
						</tr>
						<tr>
							<td><font class="header">Purchase Order No : </font></td>
							<td align="center"><font class="data">&#160;</font></td>
						</tr>
						<tr>
							<td><font class="header">Invoice Currency : </font></td>
							<td align="center"><font class="data"><xsl:value-of select="CURRENCY"/></font></td>
						</tr>
						<tr>
							<td><font class="header">Reason for Export : </font></td>
							<td align="center"><font class="data">&#160;</font></td>
						</tr>
					</table>
				</td>
			</tr>

			<tr>
				<td valign="top"><font class="header">RECEIVER (Buyer/Importer)</font><br/><font class="data"><xsl:value-of select="RECEIVER/COMPANYNAME"/><br/><xsl:value-of select="RECEIVER/STREETADDRESS1"/><br/><xsl:if test="RECEIVER/STREETADDRESS2/text()"><xsl:value-of select="RECEIVER/STREETADDRESS2"/><br/></xsl:if><xsl:if test="RECEIVER/STREETADDRESS3/text()"><xsl:value-of select="RECEIVER/STREETADDRESS3"/><br/></xsl:if><xsl:value-of select="RECEIVER/CITY"/><br/><xsl:if test="RECEIVER/PROVINCE/text()"><xsl:value-of select="RECEIVER/PROVINCE"/><br/></xsl:if><xsl:if test="RECEIVER/POSTCODE/text()"><xsl:value-of select="RECEIVER/POSTCODE"/><br/></xsl:if><xsl:value-of select="RECEIVER/COUNTRY"/><br/><xsl:value-of select="RECEIVER/CONTACTNAME"/><br/><xsl:value-of select="RECEIVER/CONTACTDIALCODE"/>&#160;<xsl:value-of select="RECEIVER/CONTACTTELEPHONE"/></font></td>
					<xsl:choose>
						<xsl:when test="DELIVERY/COMPANYNAME/text()">
							<td valign="top"><font class="header">DELIVER TO (if different from receiver)</font><br/><font class="data"><xsl:value-of select="DELIVERY/COMPANYNAME"/><br/><xsl:value-of select="DELIVERY/STREETADDRESS1"/><br/><xsl:if test="DELIVERY/STREETADDRESS2/text()"><xsl:value-of select="DELIVERY/STREETADDRESS2"/><br/></xsl:if><xsl:if test="DELIVERY/STREETADDRESS3/text()"><xsl:value-of select="DELIVERY/STREETADDRESS3"/><br/></xsl:if><xsl:value-of select="DELIVERY/CITY"/><br/><xsl:if test="DELIVERY/PROVINCE/text()"><xsl:value-of select="DELIVERY/PROVINCE"/><br/></xsl:if><xsl:if test="DELIVERY/POSTCODE/text()"><xsl:value-of select="DELIVERY/POSTCODE"/><br/></xsl:if><xsl:value-of select="DELIVERY/COUNTRY"/><br/><xsl:value-of select="DELIVERY/CONTACTNAME"/><br/><xsl:value-of select="DELIVERY/CONTACTDIALCODE"/>&#160;<xsl:value-of select="DELIVERY/CONTACTTELEPHONE"/></font></td>
						</xsl:when>

						<xsl:otherwise>
									<td valign="top"><font class="header">DELIVER TO (if different from receiver)</font></td>
						</xsl:otherwise>
					</xsl:choose>
			</tr>

									
			</table>
		<br/>

		<table width="600"  cellpadding="3" cellspacing="0" border="1">
		<tr>
			<td><font class="header">Quantity</font></td>
			<td><font class="header">Units</font></td>
			<td><font class="header">Weight</font></td>
			<td colspan="3"><font class="header">Description of Goods</font></td>
			<td><font class="header">HS Tariff Code</font></td>
			<td><font class="header">Country of Origin</font></td>
			<td><font class="header">Unit Value</font></td>
			<td><font class="header">Total Value</font></td>
		</tr>
		<xsl:for-each select="PACKAGE/ARTICLE">

		

		<tr>
			<td><font class="data"><xsl:value-of select="ITEMS"/></font></td>
			<td><font class="data">&#160;</font></td>
			<td><font class="data"><xsl:value-of select="WEIGHT"/></font></td>
			<td colspan="3"><font class="data"><xsl:value-of select="INVOICEDESC"/></font></td>
			<td><font class="data"><xsl:value-of select="HTS"/></font></td>
			<td><font class="data"><xsl:value-of select="ORIGINCOUNTRY"/></font></td>
			<td><font class="data">&#160;</font></td>
			<td><font class="data"><xsl:value-of select="INVOICEVALUE"/></font></td>
		</tr>
		</xsl:for-each>

		<tr>
			<td><font class="data">&#160;</font></td>
			<td><font class="data">&#160;</font></td>
			<td><font class="data">&#160;</font></td>
			<td colspan="3"><font class="data">&#160;</font></td>
			<td><font class="data">&#160;</font></td>
			<td><font class="data">&#160;</font></td>
			<td><font class="data">&#160;</font></td>
			<td><font class="data">&#160;</font></td>
		</tr>
		<tr>
			<td colspan="1"><font class="header">Total Weight</font></td>
			<td colspan="1"><font class="data"><xsl:value-of select="TOTALWEIGHT"/></font></td>
			<td colspan="1"><font class="header">Units of Weight</font></td>
			<td colspan="1" align="center"><font class="data"><xsl:value-of select="TOTALWEIGHT/@units"/></font></td>
			<td colspan="2"><font class="header">Total Number of Packages</font></td>
			<td colspan="1"><font class="data"><xsl:value-of select="TOTALITEMS"/></font></td>
			<td colspan="2"><font class="header">Invoice Line Total</font></td>
			<td><font class="data">&#160;</font></td>
		</tr>

		<tr>
			<td rowspan="5" colspan="7" valign="top"><font class="header">Declaration(s)</font></td>
		
		
				<td colspan="2" align="right">Discount</td>
				<td><font class="data">&#160;</font></td>
			</tr>
			<tr>
				<td colspan="2" align="right">Invoice Sub-total</td>
				<td><font class="data"><xsl:value-of select="GOODSVALUE"/>&#160;<xsl:value-of select="INSURANCECURRENCY"/></font></td>
			</tr>
			<tr>
				<td colspan="2" align="right">Freight Charges</td>
				<td><font class="data">&#160;</font></td>
			</tr>
			<tr>
				<td colspan="2" align="right">Insurance</td>
				<td><font class="data"><xsl:value-of select="INSURANCEVALUE"/>&#160;<xsl:value-of select="INSURANCECURRENCY"/></font></td>
			</tr>
			<tr>
				<td colspan="2" align="right">Other Charges</td>
				<td><font class="data">&#160;</font></td>
			</tr>

			<tr>
				<td colspan="6" align="center"><font class="header">INCO Terms</font></td>
				<td><font class="data">&#160;</font></td>
				<td colspan="2" align="right"><font class="header">Invoice Total</font></td>
				<td><font class="data">&#160;</font></td>
			</tr>


		
		

		
	

		</table>
		
		<br/>
		<table width="600"  cellpadding="3" cellspacing="0" border="1">
			<tr>
				<td><font class="header">Shipper Name and Job Title</font></td>
				<td><font class="header">Shipper Signature</font></td>
				<td><font class="header">Date</font></td>
			</tr>
			<tr>
				<td>&#160;</td>
				<td>&#160;</td>
				<td>
							<font class="data">
							<script type="text/javascript">
							var d = new Date()
							document.write(d.getDate())
							document.write("/")
							document.write(d.getMonth() + 1)
							document.write("/")
							document.write(d.getFullYear())
							</script></font></td>
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

						<xsl:if test="$Copy &lt; $Copies">
						<div>
							<font size="1" color="#5FFFFF">.</font>
						</div>
						</xsl:if>
		

<xsl:call-template name="Invoice">
	<xsl:with-param name="Copy" select="$Copy+1"/>
	<xsl:with-param name="Copies" select="$Copies"/>
</xsl:call-template>
</xsl:if>
</xsl:template>	
			
		
		

</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario2" userelativepaths="yes" externalpreview="no" url="file://c:\Documents and Settings\g466ahe\Desktop\invoice.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->