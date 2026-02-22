package org.example;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class Main {
    public static void main(String[] args) throws Exception {
        String env = System.getenv().getOrDefault("APP_ENV", "unknown");
        String version = System.getenv().getOrDefault("APP_VERSION", "dev");

        // PORT од environment variable, default 8089
        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8089"));

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);

        server.createContext("/", exchange -> {
            String response = "DevOps Homework4 test - " + env + " version=" + version;
            sendResponse(exchange, response);
        });

        server.createContext("/health", exchange -> {
            sendResponse(exchange, "OK");
        });

        server.createContext("/version", exchange -> {
            String response = "env=" + env + ", version=" + version;
            sendResponse(exchange, response);
        });

        server.setExecutor(null);
        server.start();

        System.out.println("Server started on port " + port + " | env=" + env + " | version=" + version);
    }

    private static void sendResponse(HttpExchange exchange, String response) throws IOException {
        exchange.sendResponseHeaders(200, response.getBytes().length);
        try (OutputStream os = exchange.getResponseBody()) {
            os.write(response.getBytes());
        }
    }
}