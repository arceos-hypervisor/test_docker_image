# 使用官方 Rust 镜像作为基础镜像
FROM rust:latest

# 设置工作目录
WORKDIR /usr/src/tangram-crates

# 复制当前项目文件到容器中
COPY . .

# 进行构建（假设你的项目是一个 Rust 项目）
RUN cargo build --release

# 设置容器启动命令（如果是一个服务或者可执行文件）
CMD ["./target/release/tangram-crates"]
