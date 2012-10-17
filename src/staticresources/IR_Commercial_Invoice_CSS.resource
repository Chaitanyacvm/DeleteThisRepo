/* General styles
========================================*/
body { /* margin: 0px; */
    color: #000;
    font-family: Arial, Tahoma, Verdana;
    font-size: 10pt;
    background: url("../_img/background_page.gif") #fff top repeat-x;
}

body#HelpPopup {
    background-color: #EEE;
    padding: 10px;
    background-image: none;
}

a {
    color: #f60;
    outline-color: #f60 !important;
    outline: none;
}

img {
    border: none;
}

a:hover {
    text-decoration: none;
}

p {
    margin-top: 0;
}

#content ul,#contentExtra ul {
    margin: 0 0 10px 0;
    padding: 0 0 0 15px;
    list-style-type: square;
}

h1,h2,h3 {
    margin-top: 0;
    font-family: tahoma, helvetica, sans-serif;
    font-weight: normal;
}

h1 {
    font-size: 125%;
}

h2 {
    margin-bottom: 0.5em;
    font-size: 135%;
}

h3 {
    margin-bottom: 0.4em;
    font-size: 115%;
    color: #333;
}

.hr {
    border-top: 1px solid #CCC;
    clear: both;
}

.clr {
    clear: both;
    line-height: 1px;
    height: 1px;
    font-size: 1px;
}

.hide {
    display: none;
}

.orange,#content h3.orange {
    color: #F60;
}

.nowrap {
    white-space: nowrap;
}

.contentDevider {
    padding-top: 10px;
    margin-top: 10px;
    /* border replaced with gray one due to TNTREDEV-408 */
    /* background: url("../_img/hr_orange_grey.gif") top right no-repeat; */
    border-top: 1px solid #CCCCCC;
}

/* Content 
========================================*/
#content {
    margin-left: auto;
    margin-right: auto;
    width: 510px;
    margin-top: -36px;
    padding: 0;
    line-height: 150%;
    font-size: 95%;
    color: #444;
}

#content img.format {
    margin: 0 10px 10px 0px;
    border: solid 1px #ccc;
    padding: 1px;
    float: left;
    display: inline;
}

#content img.alternateside {
    float: right;
    margin-right: 0;
    margin-left: 10px;
}

#content img.fixed {
    float: none;
    display: inline;
    margin: 0;
}

#content img.nostyle {
    padding: 0;
    border: 0;
}

#content .body {
    margin: 0 14px 0 14px;
}

#content a.top {
    clear: both;
    margin: 14px 0;
}

#content span.colon {
    display: block;
    margin-bottom: 10px;
    font-weight: bold;
}

#content span.colon strong {
    color: #444;
    font-weight: normal;
}

#content .alsoInterested {
    margin: 10px 0;
    border: 1px solid #b2b2b2;
    border-left: none;
    border-right: none;
    padding: 2px 0 2px 0;
}

#content .alsoInterested p {
    margin: 0;
    background: #e7e7e7;
    padding: 6px 10px;
}

/* Content  Header
========================================*/
#content .header {
    height: 97px;
    padding: 0;
    margin-bottom: 10px;
    border: solid 1px #ccc;
    overflow: hidden;
    background: #fff no-repeat 1px;
}

#content .header div.bg {
    height: 95px;
    border: solid 1px #FFF;
}

#content .header div.float {
    width: 150px;
    float: left;
}

#content .header span {
    display: block;
    margin: 0;
    padding: 0;
    width: 150px;
    height: 95px;
    line-height: 105%;
    /*background: transparent url("../_img/body_header_strips.png");*/
    float: left;
    z-index: 0;
    text-transform: uppercase;
}

#content .header h1 {
    color: #FFF;
    float: left;
    margin: 15pt 0 0 -150px;
    text-transform: uppercase;
    padding:3pt 0pt;
    width: 150px;
    z-index: 0;
    text-align: right;
    display: block;
    font-size: 155%;
    background-color: #f60;
}

#content .header h1 b {
    z-index: 0;
    font-weight: normal;
    display: block;
    margin: 2px 10px 3px 10px;
}

#content .header img {
    border: none;
}

/* Content  Headers
========================================*/
#content h1 {
    margin-bottom: 3px;
}

#content h2 {
    color: #ff6600;
    font-size: 100%;
    font-weight: bold;
    line-height: 100%;
    border-top: 1px solid #CCC;
    padding-top: 12px;
}

#content h3,h4 {
    font-size: 100%;
    line-height: 100%;
    font-weight: bold;
    margin-bottom: 12px;
}

#content h3 {
    line-height: 140%;
    color: #666;
}

#content h4 {
    margin-bottom: 0;
}

/* Content  Introduction
========================================*/
#content strong.intro {
    margin-top: 8px;
    display: block;
}

/* Content  Lists
========================================*/
#content ul {
    list-style: square;
}

#content ul ul {
    list-style-image: url("../_img/dash.gif")
}

#content ul.points {
    list-style: square;
    list-style-position: inside;
    text-indent: 0px;
    color: #F60;
    margin-left: 0;
    padding-left: 0;
}

#content ul.points li {
    margin-bottom: 8px;
}

#content ul.points strong {
    color: #444;
    margin: 0 4px 0 -5px;
}

#content ul.points p {
    display: inline;
    color: #444;
}

#content ul.links {
    list-style: square;
    list-style-image: url("../_img/menu_bullet.gif");
    list-style-position: outside;
    text-indent: 0px;
    color: #F60;
    margin: 0 0 15px 15px;
    padding: 0;
    clear: both;
}

#content ul.links li {
    margin: 0 0 14px 0;
    padding: 0;
    line-height: 100%;
    margin-bottom: 6px;
}

#content ul.links li a {
    margin: 0 -3px 0 -3px;
}