<%@page import="java.io.InputStream"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
 final String dbURL = "jdbc:mysql://192.168.18.245:3306/javadb_167";
 final String dbUser = "javadb_167";
final String dbPass = "ben#u62000";
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");

InputStream inputStream = null;	// input stream of the upload file

// obtains the upload file part in this multipart request
Part filePart = request.getPart("photo");
if (filePart != null) {
	// prints out some information for debugging
	System.out.println(filePart.getName());
	System.out.println(filePart.getSize());
	System.out.println(filePart.getContentType());
	
	// obtains input stream of the upload file
	inputStream = filePart.getInputStream();
}

Connection conn = null;	// connection to the database
String message = null;	// message will be sent back to client

try {
	// connects to the database
	DriverManager.registerDriver(new com.mysql.jdbc.Driver());
	conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

	// constructs SQL statement
	String sql = "INSERT INTO contacts (first_name, last_name, photo) values (?, ?, ?)";
	PreparedStatement statement = conn.prepareStatement(sql);
	statement.setString(1, firstName);
	statement.setString(2, lastName);
	
	if (inputStream != null) {
		// fetches input stream of the upload file for the blob column
		statement.setBlob(3, inputStream);
	}

	// sends the statement to the database server
	int row = statement.executeUpdate();
	if (row > 0) {
		message = "File uploaded and saved into database";
	}
} catch (SQLException ex) {
	message = "ERROR: " + ex.getMessage();
	ex.printStackTrace();
} finally {
	if (conn != null) {
		// closes the database connection
		try {
			conn.close();
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
	}
	// sets the message in request scope
	request.setAttribute("Message", message);
	
	// forwards to the message page
	getServletContext().getRequestDispatcher("/Message.jsp").forward(request, response);
}


%>
