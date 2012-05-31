package com.powerboot.dao.mapper;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import au.com.bytecode.opencsv.CSVReader;

import com.google.gdata.client.Service.GDataRequest;
import com.powerboot.model.HikeModel;

public class HikesRowMapper {
    
    /**
      * Returns the Fusion Tables CSV response as a {@code QueryResults} object.
      *
      * @return an object containing a list of column names and a list of row values from the
      *         Fusion Tables response
      */
    @SuppressWarnings({ "unchecked", "unused" })
    public Object mapGFusionTableRows(GDataRequest request) throws IOException {
        InputStreamReader inputStreamReader = new InputStreamReader(request.getResponseStream());
        BufferedReader bufferedStreamReader = new BufferedReader(inputStreamReader);
        CSVReader reader = new CSVReader(bufferedStreamReader);
        // The first line is the column names, and the remaining lines are the rows.
        List<String[]> csvLines = reader.readAll();
        List<String[]> rows = csvLines.subList(1, csvLines.size());
        
        //map the result set to create a List<HikeListModel>
        List<HikeModel> hikeList = new ArrayList<HikeModel>();
        
        HikesResultSetExtractor extractor = new HikesResultSetExtractor();
        
        for(String[] row: rows) {
            HikeModel hike = extractor.extractData(row);
            hikeList.add(hike);
        }
        
        return hikeList;
        
    }

}