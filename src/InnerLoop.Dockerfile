FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS publish

WORKDIR /src

EXPOSE 5000
ENV DOTNET_WATCH_RESTART_ON_RUDE_EDIT=true
ENV ASPNETCORE_URLS=http://+:5000

RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /src
USER appuser

RUN dotnet dev-certs https --clean && dotnet dev-certs https
ENTRYPOINT ["dotnet", "watch"]
