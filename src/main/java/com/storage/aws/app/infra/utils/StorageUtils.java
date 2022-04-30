package com.storage.aws.app.infra.utils;

import java.util.UUID;

import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

public class StorageUtils {
	public static class S3 {
		
		private static final String S3_BASE_URL_BUCKET_LOCATION = "https://%s.s3.%s.amazonaws.com";
		
		private static final String S3_BASE_URL_REGEX =  "^https:\\/\\/[\\w-]+.s3.amazonaws.com";
				
		public String getBucketLocationUrl(String bucketName,String region) {
			return String.format(S3_BASE_URL_BUCKET_LOCATION,bucketName, region);
		}
		
		public static String getKeyFileLocation(String s3FileLocation){
			return s3FileLocation.split(S3_BASE_URL_REGEX)[1].replaceFirst("/", "").trim();
		}
	}
	
	public static String generateRandomFilename(MultipartFile multipartfile) {
		String extension = StringUtils.getFilenameExtension(multipartfile.getOriginalFilename());
		String randomName = UUID.randomUUID().toString().concat(".").concat(extension);
		return randomName;
		
	}
 
	
}
