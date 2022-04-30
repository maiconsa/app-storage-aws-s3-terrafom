package com.storage.aws.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;

@SpringBootApplication
public class AppStorageAwsS3TerraformApplication {

	public static void main(String[] args) {
		SpringApplication.run(AppStorageAwsS3TerraformApplication.class, args);
	}

	
	@EventListener(classes = ApplicationReadyEvent.class)
	public void appReady( ) {
	
	}
	
}
