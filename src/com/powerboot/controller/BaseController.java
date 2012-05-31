package com.powerboot.controller;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public abstract class BaseController {
	ApplicationContext context = new ClassPathXmlApplicationContext("spring-beans.xml");
}
