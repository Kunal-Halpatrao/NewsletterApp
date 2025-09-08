<%@ page import="java.sql.*, javax.mail.*, javax.mail.internet.*, java.util.Properties" %>
<%
    String email = request.getParameter("email");
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmailAppDB", "root", "Kunal@123");

        String query = "DELETE FROM subscribers WHERE email = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, email);
        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
            // Send Unsubscription Confirmation Email
            final String senderEmail = "halpatraokunal6@gmail.com";  // Replace with your email
            final String senderPassword = "jzen ojyy sjvm mqpx"; // Replace with your email password or App Password

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            Session mailSession = Session.getInstance(props, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, senderPassword);
                }
            });

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Unsubscription Confirmation");
            message.setText("You have successfully unsubscribed from our newsletter. If this was a mistake, you can subscribe again.");

            Transport.send(message);

            out.println("Unsubscribed Successfully! Confirmation email sent.");
        } else {
            out.println("Email Not Found!");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
