package com.powerboot.facade;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;

import com.google.gdata.client.ClientLoginAccountType;
import com.google.gdata.client.GoogleService;
import com.google.gdata.client.Service.GDataRequest;
import com.google.gdata.client.Service.GDataRequest.RequestType;
import com.google.gdata.util.AuthenticationException;
import com.google.gdata.util.ContentType;
import com.google.gdata.util.ServiceException;
import com.powerboot.dao.mapper.HikesRowMapper;

public class GFusionFacade {
    /**
     * Google Fusion Tables API URL. 
     * All requests to the Google Fusion Tables service begin with this URL.
     */
    private static final String SERVICE_URL = "https://www.google.com/fusiontables/api/query";
    private GoogleService googleService;
    private String email;
    private String password;
    private static GFusionFacade instance = null;
    
    private GFusionFacade() {};
    
    public static GFusionFacade getInstance() {
        if(instance == null) {
           instance = new GFusionFacade();
        }
        return instance;
     }

    public void init () throws AuthenticationException {
        this.googleService.setUserCredentials(this.email, this.password, ClientLoginAccountType.GOOGLE);
    }

    /**
     * Returns the results of running a Fusion Tables SQL query.
     *
     * @param  query the SQL query to send to Fusion Tables
     * @param  isUsingEncId includes the encrypted table ID in the result if {@code true}, otherwise
     *         includes the numeric table ID
     * @return the results from the Fusion Tables SQL query
     * @throws IOException when there is an error writing to or reading from GData service
     * @throws ServiceException when the request to the Fusion Tables service fails
     * @see    com.google.gdata.util.ServiceException
     */
    @SuppressWarnings("unchecked")
    public <T> List<T> executeQuery (String query, HikesRowMapper rowMapper) throws IOException, ServiceException {
        String lowercaseQuery = query.toLowerCase();
        String encodedQuery = URLEncoder.encode(query, "UTF-8");

        GDataRequest request;
        // If the query is a select, describe, or show query, run a GET request.
        if (lowercaseQuery.startsWith("select") ||
                lowercaseQuery.startsWith("describe") ||
                lowercaseQuery.startsWith("show")) {
            URL url = new URL(SERVICE_URL + "?sql=" + encodedQuery + "&encid=" + false);
            request = this.googleService.getRequestFactory().getRequest(RequestType.QUERY, url,
                    ContentType.TEXT_PLAIN);
        } else {
            // Otherwise, run a POST request.
            URL url = new URL(SERVICE_URL + "?encid=" + false);
            request = this.googleService.getRequestFactory().getRequest(RequestType.INSERT, url,
                    new ContentType("application/x-www-form-urlencoded"));
            OutputStreamWriter writer = new OutputStreamWriter(request.getRequestStream());
            writer.append("sql=" + encodedQuery);
            writer.flush();
        }

        request.execute();
        
        return (List<T>) rowMapper.mapGFusionTableRows(request);
    }
    
    public GoogleService getGoogleService() {
        return googleService;
    }

    public void setGoogleService(GoogleService googleService) {
        this.googleService = googleService;
    }

    public GoogleService getService() {
        return this.googleService;
    }

    public void setService(GoogleService service) {
        this.googleService = service;
    }
    
    public void setEmail(String email) {
		this.email = email;
	}

	public void setPassword(String password) {
		this.password = password;
	}

}
