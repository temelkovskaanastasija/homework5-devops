import org.junit.jupiter.api.Test;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class IntegrationTest {

    @Test
    void applicationStartsSuccessfully() throws Exception {
        URL url = new URL("http://localhost:8080/health");
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");

        int code = con.getResponseCode();
        assertEquals(200, code);

        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String body = in.readLine();
        in.close();

        assertEquals("OK", body);
    }
}