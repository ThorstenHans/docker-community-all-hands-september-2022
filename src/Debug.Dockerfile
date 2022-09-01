FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base

WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000

WORKDIR /remote_debugger

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://aka.ms/getvsdbgsh --output install_vs_dbg.sh


# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app /remote_debugger
USER appuser

RUN chmod +x install_vs_dbg.sh && ./install_vs_dbg.sh -v latest -l /remote_debugger


FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS publish
WORKDIR /src
COPY ["ThorstenHans.SampleApi.csproj", "./"]
RUN dotnet restore "ThorstenHans.SampleApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet publish "ThorstenHans.SampleApi.csproj" --no-restore -c Debug -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --chown=appuser --from=publish /app/publish .

ENTRYPOINT ["dotnet", "ThorstenHans.SampleApi.dll"]
