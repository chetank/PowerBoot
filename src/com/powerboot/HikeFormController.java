package com.powerboot;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import com.powerboot.jdbc.JDBCConnector;
import com.powerboot.model.HikeDetailsCommand;

public class HikeFormController extends SimpleFormController {
    
    String name;
    String location;    

    protected static Logger myLogger = Logger.getLogger(JDBCConnector.class.getName());

    public HikeFormController() {
        setCommandClass(HikeDetailsCommand.class);
        setCommandName("name");
    }
    
    public String referenceData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String now = (new Date()).toString();
        logger.info("Returning hello view with " + now);
        return now;
    }
    
    protected ModelAndView onSubmit(Object command,BindException exception) throws Exception {
        HikeDetailsCommand name = (HikeDetailsCommand) command;
        JDBCConnector conn = new JDBCConnector();
        conn.getStatement().executeUpdate("INSERT INTO hikedetails VALUES ('test', 'test', 1)");
        conn.getStatement().close();
        conn.getConnection().close();
        
        return new ModelAndView("displayname","name",name);
    }
    
    public void setUserName(String name) {
        this.name = name;
    }
    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getUserName() {
        return name;
    }
}