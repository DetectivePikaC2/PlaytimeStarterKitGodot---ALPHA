shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, cull_back;

uniform sampler2D base_texture;
uniform sampler2D mask_texture;
uniform float alpha_threshold = 0.5; // Adjust for fine-tuning

void fragment() {
    vec4 base_color = texture(base_texture, UV);
    float mask = texture(mask_texture, UV).r;

    ALBEDO = base_color.rgb;
    ALPHA = 1.0 - mask;

    if (ALPHA < alpha_threshold) {
        ALPHA = 0.0; // Forces a hard cutout instead of discard
    }
}
