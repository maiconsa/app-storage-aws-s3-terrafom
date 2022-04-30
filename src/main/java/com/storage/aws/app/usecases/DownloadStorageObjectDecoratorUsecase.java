package com.storage.aws.app.usecases;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import org.springframework.http.MediaType;

import com.storage.aws.app.infra.StorageProvider.StorageObject;

public class DownloadStorageObjectDecoratorUsecase implements UsecaseService<DownloadObjectRequest<OutputStream>, StorageObject> {
	private UsecaseService<DownloadObjectRequest<OutputStream>, StorageObject> other;
	private HttpServletResponse response;

	public DownloadStorageObjectDecoratorUsecase(HttpServletResponse response,
			UsecaseService<DownloadObjectRequest<OutputStream>, StorageObject> other) {
		this.response = response;
		this.other = other;
	}

	@Override
	public StorageObject apply(DownloadObjectRequest<OutputStream> t) {

		try {
			StorageObject object = other.apply(t);
			response.addHeader("Content-Disposition", "attachment; filename=" + object.getName());
			response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
			response.getOutputStream().flush();

			return object;
		} catch (IOException e) {
			throw new UseCaseException(e.getMessage());
		}

	}
}
