package com.powerboot.controller;

import java.util.List;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import com.powerboot.dao.HikesDao;
import com.powerboot.dao.HikesDaoImpl;
import com.powerboot.model.HikeModel;

public class HikeListController extends BaseController implements Controller {

    protected static Logger myLogger = Logger.getLogger(HikeListController.class.getName());
    
    
    public ModelAndView handleRequest(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
  
        HikesDao dao = (HikesDaoImpl) context.getBean("hikesDAO");
        List<HikeModel> hikeList = dao.selectAll();
        
        
        ModelAndView modelAndView = new ModelAndView("home");
        modelAndView.addObject("hikeList", hikeList);
        
        
        return modelAndView;
    }
}
