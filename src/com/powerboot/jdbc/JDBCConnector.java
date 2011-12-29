package com.powerboot.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.powerboot.log.LoggingConfiguration;

public class JDBCConnector {
    private Statement statement;
    private Connection connection;
    protected static Logger myLogger = Logger.getLogger(JDBCConnector.class.getName());

    public JDBCConnector() {
        try {
            myLogger.addHandler(LoggingConfiguration.getLoggingConfiguration());
            String driverName = "com.mysql.jdbc.Driver"; // MySQL MM JDBC driver
            String serverName = "localhost";
            String mydatabase = "sakila";
            String url = "jdbc:mysql://" + serverName +  "/" + mydatabase; // a JDBC url
            String username = "root";
            String password = "test123";
            Class.forName(driverName);
            this.connection = DriverManager.getConnection(url, username, password);
            this.statement = this.connection.createStatement();
        } catch (ClassNotFoundException e) {
            myLogger.log(Level.SEVERE, "JDBC Driver was not found.", e);
        } catch (SQLException e) {
            myLogger.log(Level.SEVERE, "An SQL Exception occurred.", e);
        }
    }
    
    public Connection getConnection() {
        return connection;
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
    }

    public Statement getStatement() {
        return statement;
    }

    public void setStatement(Statement statement) {
        this.statement = statement;
    }
}
