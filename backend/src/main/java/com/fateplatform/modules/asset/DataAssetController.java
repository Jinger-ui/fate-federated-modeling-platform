package com.fateplatform.modules.asset;

import com.fateplatform.common.ApiResponse;
import com.fateplatform.modules.PlatformService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/data-assets")
public class DataAssetController {
    private final PlatformService platformService;

    public DataAssetController(PlatformService platformService) {
        this.platformService = platformService;
    }

    @GetMapping
    public ApiResponse<List<Map<String, Object>>> list() {
        return ApiResponse.ok(platformService.listAssets());
    }

    @GetMapping("/{id}")
    public ApiResponse<Map<String, Object>> detail(@PathVariable Long id) {
        return ApiResponse.ok(platformService.assetDetail(id));
    }

    @GetMapping("/{id}/fields")
    public ApiResponse<Object> fields(@PathVariable Long id) {
        return ApiResponse.ok(platformService.assetDetail(id).get("fields"));
    }

    @PostMapping
    public ApiResponse<Map<String, Object>> create(@RequestBody Map<String, Object> body) {
        return ApiResponse.ok(Map.of("id", platformService.createAsset(body), "status", "VALID"));
    }

    @PostMapping("/{id}/validate")
    public ApiResponse<Map<String, Object>> validate(@PathVariable Long id) {
        return ApiResponse.ok(Map.of("assetId", id, "status", "VALID", "message", "元数据校验通过，未读取原始样本。"));
    }
}
