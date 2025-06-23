# Dockerfile
FROM ruby:3.1.2

# Node.js (npm含む) をインストール
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get update -y \
  && apt-get install -y nodejs git

# 作業ディレクトリを作成
WORKDIR /app

# Gemfile と Gemfile.lock を先にコピーして bundle install（キャッシュ効率）
COPY Gemfile Gemfile.lock ./
RUN bundle install

# package.json と package-lock.json をコピーして npm install
COPY package.json package-lock.json ./
RUN npm install

# アプリ全体をコピー
COPY . .

# ポートを開放（Rails用）
EXPOSE 3000

# 起動コマンド（vite_rails は bin/rails 経由で動作）
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
