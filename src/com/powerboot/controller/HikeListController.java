package com.powerboot.controller;

import java.util.List;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import com.powerboot.dao.HikesListDao;
import com.powerboot.dao.HikesListIDao;
import com.powerboot.model.HikeListModel;

public class HikeListController extends SimpleFormController {

    protected static Logger myLogger = Logger.getLogger(HikeListController.class.getName());
    
    
    public ModelAndView handleRequest(HttpServletRequest arg0,
            HttpServletResponse arg1) throws Exception {
  
        HikesListIDao dao = new HikesListDao();
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost/sakila");
        dataSource.setUsername("root");
        dataSource.setPassword("test123");
        dao.setDataSource(dataSource);

        List<HikeListModel> hikeList = dao.selectAll();
        
        ModelAndView modelAndView = new ModelAndView("hikelist");
        modelAndView.addObject("hikeList", hikeList);
        return modelAndView;
    }
}
