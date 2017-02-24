FROM crystallang/crystal
RUN apt-get update && apt-get install gnupg libgpgme11-dev
