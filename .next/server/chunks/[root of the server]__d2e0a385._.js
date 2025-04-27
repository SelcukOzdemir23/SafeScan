module.exports = {

"[project]/.next-internal/server/app/api/check-url/route/actions.js [app-rsc] (server actions loader, ecmascript)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
}}),
"[externals]/next/dist/compiled/next-server/app-route.runtime.dev.js [external] (next/dist/compiled/next-server/app-route.runtime.dev.js, cjs)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
const mod = __turbopack_context__.x("next/dist/compiled/next-server/app-route.runtime.dev.js", () => require("next/dist/compiled/next-server/app-route.runtime.dev.js"));

module.exports = mod;
}}),
"[externals]/@opentelemetry/api [external] (@opentelemetry/api, cjs)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
const mod = __turbopack_context__.x("@opentelemetry/api", () => require("@opentelemetry/api"));

module.exports = mod;
}}),
"[externals]/next/dist/compiled/next-server/app-page.runtime.dev.js [external] (next/dist/compiled/next-server/app-page.runtime.dev.js, cjs)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
const mod = __turbopack_context__.x("next/dist/compiled/next-server/app-page.runtime.dev.js", () => require("next/dist/compiled/next-server/app-page.runtime.dev.js"));

module.exports = mod;
}}),
"[externals]/next/dist/server/app-render/work-unit-async-storage.external.js [external] (next/dist/server/app-render/work-unit-async-storage.external.js, cjs)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
const mod = __turbopack_context__.x("next/dist/server/app-render/work-unit-async-storage.external.js", () => require("next/dist/server/app-render/work-unit-async-storage.external.js"));

module.exports = mod;
}}),
"[externals]/next/dist/server/app-render/work-async-storage.external.js [external] (next/dist/server/app-render/work-async-storage.external.js, cjs)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
const mod = __turbopack_context__.x("next/dist/server/app-render/work-async-storage.external.js", () => require("next/dist/server/app-render/work-async-storage.external.js"));

module.exports = mod;
}}),
"[externals]/next/dist/server/app-render/after-task-async-storage.external.js [external] (next/dist/server/app-render/after-task-async-storage.external.js, cjs)": (function(__turbopack_context__) {

var { g: global, __dirname, m: module, e: exports } = __turbopack_context__;
{
const mod = __turbopack_context__.x("next/dist/server/app-render/after-task-async-storage.external.js", () => require("next/dist/server/app-render/after-task-async-storage.external.js"));

module.exports = mod;
}}),
"[project]/src/app/api/check-url/route.ts [app-route] (ecmascript)": ((__turbopack_context__) => {
"use strict";

var { g: global, __dirname } = __turbopack_context__;
{
__turbopack_context__.s({
    "POST": (()=>POST)
});
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$server$2e$js__$5b$app$2d$route$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/server.js [app-route] (ecmascript)");
;
// --- Basic Malicious Domain Check (Demonstration) ---
// WARNING: This is a very basic check and not a substitute for a proper safety API.
// It only checks against a small, hardcoded list of *domains*.
// A real implementation would need a much larger, frequently updated list.
const KNOWN_BAD_DOMAINS = new Set([
    'example-malware-domain.com',
    'phishing-site-example.net',
    'suspicious-activity.org'
]);
async function POST(request) {
    // 1. Parse Request Body
    let body;
    try {
        body = await request.json();
    } catch (error) {
        return __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$server$2e$js__$5b$app$2d$route$5d$__$28$ecmascript$29$__["NextResponse"].json({
            error: 'Invalid request body. Expected JSON.'
        }, {
            status: 400
        });
    }
    const urlToCheck = body.url;
    // 2. Validate Input URL
    if (!urlToCheck || typeof urlToCheck !== 'string') {
        return __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$server$2e$js__$5b$app$2d$route$5d$__$28$ecmascript$29$__["NextResponse"].json({
            error: 'URL is required in the request body.'
        }, {
            status: 400
        });
    }
    let parsedUrl;
    try {
        parsedUrl = new URL(urlToCheck);
    } catch (_) {
        console.warn(`Invalid URL format received: ${urlToCheck}`);
        return __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$server$2e$js__$5b$app$2d$route$5d$__$28$ecmascript$29$__["NextResponse"].json({
            originalUrl: urlToCheck,
            status: 'INVALID_URL',
            message: 'The provided text is not a valid URL format.'
        }, {
            status: 200
        }); // Still a successful API call, but invalid input
    }
    // 3. Perform Basic Domain Check
    try {
        const hostname = parsedUrl.hostname;
        console.log(`Checking hostname: ${hostname}`);
        let safetyStatus = 'SAFE';
        // Default message assumes safety but highlights the check's limitation
        let message = 'Domain not found on our basic list of known threats. Always exercise caution.';
        // Check against the known bad domains list
        if (KNOWN_BAD_DOMAINS.has(hostname.toLowerCase())) {
            safetyStatus = 'UNSAFE';
            message = `Warning: The domain '${hostname}' is on a list of known threats. Avoid visiting this URL.`;
            console.warn(`Malicious domain detected: ${hostname}`);
        } else {
            console.log(`Domain ${hostname} not found in the basic threat list.`);
        }
        // Return the processed result to the client
        return __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$server$2e$js__$5b$app$2d$route$5d$__$28$ecmascript$29$__["NextResponse"].json({
            originalUrl: urlToCheck,
            status: safetyStatus,
            message: message
        });
    } catch (error) {
        console.error('Error during basic domain check:', error);
        return __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$server$2e$js__$5b$app$2d$route$5d$__$28$ecmascript$29$__["NextResponse"].json({
            originalUrl: urlToCheck,
            status: 'ERROR',
            message: 'An unexpected error occurred while checking the URL.'
        });
    }
}
}}),

};

//# sourceMappingURL=%5Broot%20of%20the%20server%5D__d2e0a385._.js.map