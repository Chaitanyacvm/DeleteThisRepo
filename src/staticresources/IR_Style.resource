a {
	color:#000;
}

img {
	border-style: none;
}

input {
	border: 1px solid #CCCCCC;
	height: 13px;
	font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	text-align: left;
	vertical-align: middle;
	padding-top: 2px;
	padding-right: 3px;
	padding-bottom: 3px;
	padding-left: 5px;
	margin-top: 2px;
    margin-left:9px;
}

input[type="checkbox"] {
	border:0px;
}

label {
	text-align: left;
	vertical-align: middle;
}

.short-input {
	width: 70px;
}

select {
	border: 1px solid #CCCCCC;
	font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	padding: 2px;
	margin-top: 1px;
	margin-right: 0px;
	margin-bottom: 0px;
    margin-left:9px;
}

body {
	font-family: Tahoma, Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
}

.clear {
	position:relative;
	clear:both;
}

.wrapper {
	width:930px;
}

h2 {
	font-size: 22px;
	color: #FF6600;
	font-weight: normal;
	text-decoration:none;
	padding-bottom:5px;
    margin-bottom:0px;
    margin-top:0px;
}

h4 {
	font-family: 'Verdana', 'Geneva', sans-serif;
	font-size: 100%;
	margin:0px;
}

table {
	padding:0px 0px 0px 0px;
	margin:0px 0px 0px 0px;
}

#standardTable td {
    padding-left:3px;
    padding-top:1px;
    vertical-align:middle;
    white-space:normal;
}

.fullInput {
    width:80%;
}

.header {
	position:relative;
	width:auto;
}

.sectionMain {
	border:1px solid #CCCCCC;
	padding:1px 1px 1px 1px;
}

.sectionHeader {
	background-color:#FF6600;
	color:#FFFFFF;
	width:auto;
	height:auto;
	padding-left:10px;
	padding-top:5px;
	padding-bottom:5px;
	white-space:nowrap;
}

.sectionBody {
	background-color:#EEEEEE;
	color:#000000;
	height:auto;
	width:auto;
	line-height:150%;
	padding-left:10px;
	padding-top:5px;
	padding-bottom:5px;
	white-space:nowrap;
}

.bottomButtons {
	position:relative;
	float:right;
	width:auto;
}

.table-keyline {
	border: 1px solid #CCCCCC;
}

#packagesTable  {
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: none;
	border-right-style: none;
	border-bottom-style: none;
	border-left-style: solid;
	border-top-color: #CCCCCC;
	border-right-color: #CCCCCC;
	border-bottom-color: #CCCCCC;
	border-left-color: #CCCCCC;
	padding-top: 3px;
	padding-right: 6px;
	padding-bottom: 3px;
	padding-left: 6px;
}

.packagesCell {
	text-align:left;
}

.packagesTableHeader {
	text-align:left;
	font-weight:bold;
	background:#FDE3D2;
	background:-moz-linear-gradient(top, #FFFFFF, #FBC6A4);
	background:-webkit-gradient(linear, left top, left bottom, from(#FFFFFF), to(#FBC6A4));
	filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='#FBC6A4', startColorstr='#FFFFFF', gradientType='0');
}

#ratesTable table, th, td {
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 0px;
	border-left-width: 0px;
	border-top-style: none;
	border-right-style: none;
	border-bottom-style: none;
	border-left-style: none;
	padding-top: 3px;
	padding-right: 6px;
	padding-bottom: 3px;
	padding-left: 6px;
    white-space:normal;
}

.greyOrangeButton {
	width: 100px;
	border: 1px solid #FF6600;
	height: 20px;
	text-align: center;
	background-image: url({!URLFOR($Resource.IR_Package_Button_BG)});
	background-repeat: repeat-x;
}

.grey-button {
	display: inline-block;
	margin: 0px;
	padding: 15px 0px;
	text-decoration: none;
	background:transparent url(grey-left.jpg) no-repeat left center;
}

.grey-button span {
	display: inline-block;
	background:transparent url(grey-right.jpg) no-repeat right center;
	cursor:pointer;
}

.grey-button a {
    padding-left: 15px;
	padding-bottom: 18px;
	padding-right: 20px;
	padding-top: 15px;
	display: inline-block;
	color:#FFFFFF;
	font-family:Tahoma, Arial;
	font-size:15px;
	font-weight: bold;
	text-decoration: none;
}

.white-button {
	display: inline-block;
	margin: 0px;
	padding: 0px;
	text-decoration: none;
	background:transparent url(white-left.jpg) no-repeat left center;
}

.white-button span {
	display: inline-block;
	background:transparent url(white-right.jpg) no-repeat right center;
	cursor:pointer;
}

.white-button a {
	padding-left: 15px;
	padding-bottom: 15px;
	padding-right: 20px;
	padding-top: 14px;
	display: inline-block;
	color:#FFFFFF;
	font-family:Tahoma, Arial;
	font-size:12px;
	font-weight: bold;
	text-decoration: none;
}

.white-button-grey {
	display: inline-block;
	margin: 0px;
	padding: 0px;
	text-decoration: none;
	background:transparent url(white-left-grey.jpg) no-repeat left center;
}

.white-button-grey span {
	display: inline-block;
	background:transparent url(white-right-grey.jpg) no-repeat right center;
	cursor:default;
}

.white-button-grey a {
	padding-left: 15px;
	padding-bottom: 15px;
	padding-right: 20px;
	padding-top: 14px;
	display: inline-block;
	color:#FFFFFF;
	font-family:Tahoma, Arial;
	font-size:12px;
	font-weight: bold;
	text-decoration: none;
}

.white-button-grey a {
	padding-left: 15px;
	padding-bottom: 15px;
	padding-right: 20px;
	padding-top: 14px;
	display: inline-block;
	color:#FFFFFF;
	font-family:Tahoma, Arial;
	font-size:12px;
	font-weight: bold;
	text-decoration: none;
}

.white-button-grey span {
	padding-left: 15px;
	padding-bottom: 15px;
	padding-right: 20px;
	padding-top: 14px;
	display: inline-block;
	color:#FFFFFF;
	font-family:Tahoma, Arial;
	font-size:12px;
	font-weight: bold;
	text-decoration: none;
}

.errorMsg {
    color: #C00;
    word-wrap:break-word;
    white-space:normal;
    margin-left:10px;
}

.requiredInput {
    width:  100%;
    height:  100%;
    background-image: url({!URLFOR($Resource.IR_Required)});
    background-repeat:no-repeat;
    background-position:left center;
}