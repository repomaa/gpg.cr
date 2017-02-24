FROM crystallang/crystal
RUN apt-get update && apt-get install -y gnupg libgpgme11-dev
