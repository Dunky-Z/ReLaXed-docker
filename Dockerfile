FROM node:14.14

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

RUN git clone https://github.com/RelaxedJS/ReLaXed.git
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bk && sudo bash -c "cat << EOF > /etc/apt/sources.list \
    deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse \
    deb-src http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse \
    deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse \
    deb-src http://mirrors.aliyun.com/ubuntu/ jammy-security main restrcdicted universe multiverse \
    deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse \
    deb-src http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse \
    deb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse \
    deb-src http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse \
    deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse \
    deb-src http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse \
    EOF"
# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libgconf-2-4 \
ca-certificates \
fonts-liberation \
libappindicator3-1 \
libasound2 \
libatk-bridge2.0-0 \
libatk1.0-0 \
libc6 \
libcairo2 \
libcups2 \
libdbus-1-3 \
libexpat1 \
libfontconfig1 \
libgbm1 \
libgcc1 \
libglib2.0-0 \
libgtk-3-0 \
libnspr4 \
libnss3 \
libpango-1.0-0 \
libpangocairo-1.0-0 \
libstdc++6 \
libx11-6 \
libx11-xcb1 \
libxcb1 \
libxcomposite1 \
libxcursor1 \
libxdamage1 \
libxext6 \
libxfixes3 \
libxi6 \
libxrandr2 \
libxrender1 \
libxss1 \
libxtst6 \
lsb-release \
wget \
xdg-utils

RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

RUN npm i puppeteer@5.3.1

RUN cd ReLaXed && npm install && npm link --unsafe-perm=true

ENTRYPOINT ["dumb-init", "relaxed"]
