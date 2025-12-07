from proof_export.logger import Logger

def apply_rewrites(lines, logger: Logger):
    out = []
    for line in lines:
        if line.startswith("add ") and line.endswith(", #0"):
            logger.log("rewrite: drop add #0")
            continue
        if line.startswith("mov ") and ", #" in line:
            logger.log("rewrite: mov -> alias")
            out.append(line.replace("mov", "mov_aliased", 1))
            continue
        out.append(line)
    return out

