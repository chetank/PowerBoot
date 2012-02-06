package com.powerboot.controller;

import java.util.List;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import com.powerboot.dao.HikesListDao;
import com.powerboot.dao.HikesListIDao;
import com.powerboot.model.HikeListModel;

public class HikeListController implements Controller {

    protected static Logger myLogger = Logger.getLogger(HikeListController.class.getName());
    ApplicationContext context = new ClassPathXmlApplicationContext("spring-beans.xml");
    
    public ModelAndView handleRequest(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
  
        HikesListIDao dao = (HikesListDao) context.getBean("hikesDAO");
        List<HikeListModel> hikeList = dao.selectAll();
        
        ModelAndView modelAndView = new ModelAndView("home");
        modelAndView.addObject("hikeList", hikeList);
        
        //close the db connection
        DataSource ds = (DataSource) context.getBean("dataSource");
        ds.getConnection().close();
        
        return modelAndView;
    }
}
