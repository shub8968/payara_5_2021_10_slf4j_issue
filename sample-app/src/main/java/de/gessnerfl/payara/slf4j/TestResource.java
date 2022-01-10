package de.gessnerfl.payara.slf4j;

import org.apache.xml.security.Init;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("")
public class TestResource {
    private static final Logger LOGGER = LoggerFactory.getLogger(TestResource.class);

    @GET
    @Path("/no-santuario")
    @Produces(MediaType.TEXT_PLAIN)
    public Response testLoggingWithoutSantuario(){
        LOGGER.info("Received request without using Apache Santuario");
        try {
            return Response.ok("Successfully processed request").build();
        } finally {
            LOGGER.info("Request without using Apache Santuario completed");
        }
    }

    @GET
    @Path("/santuario")
    @Produces(MediaType.TEXT_PLAIN)
    public Response testLoggingWithSantuario(){
        LOGGER.info("Received request without using Apache Santuario");
        try {
            Init.init();
            return Response.ok("Successfully processed request").build();
        } catch (Exception e) {
            LOGGER.error("Failed to process request:", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Failed to process request because of internal error: " + e.getMessage()).build();
        } finally {
            LOGGER.info("Request without using Apache Santuario completed");
        }
    }
}
