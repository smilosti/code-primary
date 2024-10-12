# Use the official Ubuntu image as a base
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    openjdk-11-jdk \
    curl \
    net-tools \
    sudo \
    python3 \
    python3-pip \
    graphviz \
    libgraphviz-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install jupyterlab pandas torch openpyxl typedb-driver pygraphviz matplotlib networkx

# Install TypeDB
RUN wget https://repo.typedb.com/public/public-release/raw/names/typedb-all-linux-x86_64/versions/2.28.0/typedb-all-linux-x86_64-2.28.0.tar.gz \
    && mkdir -p /opt/typedb \
    && tar -xzf typedb-all-linux-x86_64-2.28.0.tar.gz -C /opt/typedb \
    && rm typedb-all-linux-x86_64-2.28.0.tar.gz \
    && ln -s /opt/typedb/typedb-all-linux-x86_64-2.28.0/typedb /usr/local/bin/typedb

# Install TypeDB Studio
RUN wget https://repo.typedb.com/public/public-release/raw/names/typedb-studio-linux-x86_64/versions/2.28.0/typedb-studio-linux-x86_64-2.28.0.tar.gz \
    && mkdir -p /opt/typedb-studio \
    && tar -xzf typedb-studio-linux-x86_64-2.28.0.tar.gz -C /opt/typedb-studio \
    && rm typedb-studio-linux-x86_64-2.28.0.tar.gz \
    && chmod +x /opt/typedb-studio/typedb-studio-linux/typedb-studio \
    && ln -s /opt/typedb-studio/typedb-studio-linux/typedb-studio /usr/local/bin/typedb-studio

# Expose ports for TypeDB, TypeDB Studio and JupyterLab
EXPOSE 1729 4104 8888

# Start both TypeDB server, TypeDB Studio and JupyterLab
CMD ["sh", "-c", "typedb server & sleep 5 && typedb-studio & jupyter lab --ip=0.0.0.0 --port 8888 --no-browser --allow-root"]
