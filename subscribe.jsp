<%@ page import="java.sql.*, java.util.*, javax.mail.*, javax.mail.internet.*, javax.mail.Session, javax.mail.Authenticator" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // Database Connection Variables
    String jdbcURL = "jdbc:mysql://localhost:3306/EmailAppDB"; // Change database name if needed
    String dbUser = "root"; // Change MySQL username
    String dbPassword = "Kunal@123"; // Change MySQL password

    // Get Email from Request
    String email = request.getParameter("email");
    if (email == null || email.isEmpty()) {
        out.println("Error: Email is required!");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Load MySQL Driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Connect to Database
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Insert Email into Database
        String query = "INSERT INTO subscribers (email) VALUES (?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, email);
        int rowsInserted = pstmt.executeUpdate();

        if (rowsInserted > 0) {
            // Email Sending Logic
            String host = "smtp.gmail.com";
            String from = "halpatraokunal6@gmail.com"; // Change to your email
            String pass = "jzen ojyy sjvm mqpx";  // Use App Password if using Gmail

            Properties properties = new Properties();
            properties.put("mail.smtp.host", host);
            properties.put("mail.smtp.port", "587");
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");

            Session mailSession = Session.getInstance(properties, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, pass);
                }
            });

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Newsletter Subscription Confirmation");
            message.setText("Thank you for subscribing!");

            try {
                Transport.send(message);
                out.println("Success: Subscription completed and email sent!");
            } catch (MessagingException me) {
                out.println("Error: Failed to send the email. " + me.getMessage());
                me.printStackTrace();
            }
        } else {
            out.println("Error: Failed to subscribe.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage()); // Debugging output
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
