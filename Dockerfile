# ==================== 第一阶段：构建环境 ====================
FROM rust:latest AS builder

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    qemu-system-riscv64 qemu-system-aarch64 qemu-system-x86 qemu-system-misc \
 && rustup target add riscv64gc-unknown-none-elf \
 && rustup target add aarch64-unknown-none-softfloat \
 && rustup target add x86_64-unknown-none \
 && rustup target add loongarch64-unknown-none \
 && cargo install cargo-clone \
 && cargo install ostool

# 设置工作目录
WORKDIR /app

# ==================== 第二阶段：运行环境 ====================
FROM rust:latest

# 从构建阶段复制 cargo 工具和依赖
COPY --from=builder /usr/local/cargo /usr/local/cargo

# 从构建阶段复制 Rust 工具链
COPY --from=builder /usr/local/rustup /usr/local/rustup

# 复制安装的系统工具（可选）
COPY --from=builder /usr/bin/qemu-* /usr/bin/

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器
COPY . .

# 设置容器启动命令
CMD ["bash"]
