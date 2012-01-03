package com.powerboot.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import com.powerboot.command.HikeDetailsCommand;

public class HelloWorldValidator implements Validator {
    public boolean supports (Class clazz) {
        return clazz.equals(HikeDetailsCommand.class);
    }

    @Override
    public void validate(Object arg0, Errors arg1) {
        // TODO Auto-generated method stub
        ValidationUtils.rejectIfEmpty(arg1, "name", "required.state", "Please enter name");
        ValidationUtils.rejectIfEmpty(arg1, "location", "required.state", "Please enter location");
        
    }

}
