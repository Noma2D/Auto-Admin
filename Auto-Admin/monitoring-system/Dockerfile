FROM python:3.8-slim

# Установка зависимостей Flask
#<<<<<<< HEAD
RUN pip install Flask
RUN pip install requests
RUN pip install gunicorn

=======
RUN pip3 install Flask 
RUN pip3 install requests
RUN pip3 install gunicorn 
#>>>>>>> refs/remotes/origin/main
# Копирование вашего приложения в образ
COPY app.py /app.py

# Установка рабочей директории
WORKDIR .

# Запуск Gunicorn для Flask
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
#ENTRYPOINT ["python3"]
#CMD gunicorn -w 4 app:app
#CMD ["app.py"]
EXPOSE 5000
