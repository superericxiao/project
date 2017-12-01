<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form align = "center"method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% 
	// Get product name to search for
	String name = request.getParameter("productName");
	boolean hasParameter = false;
	String sql = "";

	if (name == null)
		name = "";
	
	if (name.equals("")) 
	{
		out.println("<h2>All Products</h2>");
		sql = "SELECT productId, productName, price FROM Product";
	} 
	else 
	{
		out.println("<h2>Products containing '" + name + "'</h2>");
		hasParameter = true;
		sql = "SELECT productId, productName, price FROM Product WHERE productName LIKE ?";
		name = '%' + name + '%';
	}
	String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_jdwyer;";
	String uid = "jdwyer";
	String pw = "39345137";
	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	try
	{	// Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	}
	catch (java.lang.ClassNotFoundException e)
	{
		out.println("ClassNotFoundException: " +e);
	}

	try ( Connection con = DriverManager.getConnection(url, uid, pw);) 
	{			
		PreparedStatement pstmt = con.prepareStatement(sql);
		if (hasParameter)
			pstmt.setString(1, name);

		ResultSet rst = pstmt.executeQuery();
		out.println("<table><tr><th></th><th>Product Name</th><th>Price</th></tr>");
		while (rst.next()) 
		{
			out.print("<tr><td><a href=\"addcart.jsp?id=" + rst.getInt(1) + "&name=" + URLEncoder.encode(rst.getString(2), "UTF-8")
					+ "&price=" + rst.getDouble(3) + "\">Add to Cart</a></td>");
			out.println("<td>" + rst.getString(2) + "</td>" + "<td>" + currFormat.format(rst.getDouble(3))
					+ "</td></tr>");
		}
		out.println("</table>");
	} 
	catch (SQLException ex) 
	{
		out.println(ex);
	} 	
%></html>
</body>