import javax.swing.*;
import java.awt.*;
import java.net.URI;
import java.net.URL;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class SubscriptionGUI {
    public static void main(String[] args) {
        JFrame frame = new JFrame("Kamal Classes");
        frame.setSize(400, 400);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setLayout(new FlowLayout());

        JLabel label = new JLabel("Enter Email:");
        label.setBounds(50, 50, 100, 30);
        JTextField emailField = new JTextField(30);
        emailField.setBounds(160, 50, 250, 30);
        JButton subscribeBtn = new JButton("Subscribe");
        subscribeBtn.setBounds(160, 100, 120, 30);
        JButton unsubscribeBtn = new JButton("Unsubscribe");
        unsubscribeBtn.setBounds(290, 100, 120, 30);

        frame.add(label);
        frame.add(emailField);
        frame.add(subscribeBtn);
        frame.add(unsubscribeBtn);

        // Action Listeners for Buttons
        subscribeBtn.addActionListener(e -> sendRequest("subscribe.jsp", emailField.getText()));
        unsubscribeBtn.addActionListener(e -> sendRequest("unsubscribe.jsp", emailField.getText()));

        frame.setVisible(true);
    }

    private static void sendRequest(String jspPage, String email) {
    try {
        String encodedEmail = URLEncoder.encode(email, "UTF-8");
        URI uri = new URI("http://localhost:8080/NewsletterApp/" + jspPage + "?email=" + encodedEmail);
        URL url = uri.toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setDoOutput(true);
        int responseCode = conn.getResponseCode();

        if (responseCode == 200) {
            JOptionPane.showMessageDialog(null, " Send Request Successfully!");
        } else {
            JOptionPane.showMessageDialog(null, "Error: Request Failed. Server responded with: " + responseCode);
        }
    } catch (Exception ex) {
        ex.printStackTrace();
        JOptionPane.showMessageDialog(null, "Error connecting to server: " + ex.getMessage());
    }
}
}