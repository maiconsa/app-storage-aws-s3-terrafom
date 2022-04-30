package com.storage.aws.app.controllers;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.storage.aws.app.usecases.DownloadObjectRequest;
import com.storage.aws.app.usecases.DownloadStorageObjectDecoratorUsecase;
import com.storage.aws.app.usecases.FileUploadUsecase;
import com.storage.aws.app.usecases.ListObjectsUsecase;
import com.storage.aws.app.usecases.TransferStorageObjectUsecase;

@Controller
public class IndexController {
	
	@Value("${storage.s3.bucket-name}")
	private String bucketName;
	
	@Value("${cloud.aws.s3.region}")
	private String region;
	
	
	@Autowired
	private FileUploadUsecase uploadUseCase;
	
	@Autowired
	private ListObjectsUsecase listObjectsUseCase;
	
	@Autowired
	private TransferStorageObjectUsecase transferStorageObjectUsecase;
	
	
	@GetMapping
	public String index(Model model) {
		model.addAttribute("bucketName", this.bucketName);
		model.addAttribute("region", region);
		model.addAttribute("objects",listObjectsUseCase.apply("upload"));

		return"index";
	}
	
	@PostMapping(path = "/upload", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
	public String upload(@RequestParam(value = "file", required = true) MultipartFile file, Model model) {
		boolean result = uploadUseCase.apply(file);
		
		model.addAttribute("success", result);
		model.addAttribute("error", !result ? "Occour an error, try later...." : null);
		return index(model);
	}
	
	@GetMapping(path = "/download/{filename}", produces = {MediaType.APPLICATION_OCTET_STREAM_VALUE}, consumes = {MediaType.ALL_VALUE})
	public void download(@PathVariable String filename, HttpServletResponse response) {
		try {
			DownloadObjectRequest<OutputStream> downloadRequest = new DownloadObjectRequest<OutputStream>(response.getOutputStream(), filename);
			new DownloadStorageObjectDecoratorUsecase(response, transferStorageObjectUsecase).apply(downloadRequest);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
