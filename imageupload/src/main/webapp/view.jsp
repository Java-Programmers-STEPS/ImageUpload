<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<% 
Blob image = null;
Connection con = null;
byte[ ] imgData = null ;
Statement stmt = null;
ResultSet rs = null;
try {

    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://192.168.18.245:3306/javadb_167","javadb_167","ben#u62000");
    stmt = con.createStatement();
    rs = stmt.executeQuery("select photo from contacts");
    if (rs.next()) {
    image = rs.getBlob(1);
    imgData = image.getBytes(1,(int)image.length());
    } 
    else {
    out.println("Display Blob Example");
    out.println("image not found for given id>");
    return;
    }
    // display the image
    response.setContentType("image/jpg");
    OutputStream o = response.getOutputStream();
    o.write(imgData);
    o.flush();
    o.close();
} catch (Exception e) {
        out.println("Unable To Display image");
    out.println("Image Display Error=" + e.getMessage());
    return;
    } 

%>