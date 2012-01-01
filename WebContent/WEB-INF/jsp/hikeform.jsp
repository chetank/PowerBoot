<%@ include file="header.jsp" %>

<html>
  <head><title>PowerBoot</title></head>
  <body>
  <h1>Hike Details</h1>
  
  <form:form method="post" commandName="insertHikeDetails">
  <table width="50%" bgcolor="#CFECEC" border="1" cellspacing="2" cellpadding="2">
    <tr>
      <td align="right">Name</td>
      <td><form:input path="name"/></td>
      <td><form:errors path="name"/></td>
    </tr>
    <tr>
      <td align="right">Location</td>
      <td><form:input path="location"/></td>
      <td><form:errors path="location"/></td>
    </tr>
  </table>
  <input type="submit" align="center" value="Execute">
  </form:form>
  <br>
  </body>
</html>