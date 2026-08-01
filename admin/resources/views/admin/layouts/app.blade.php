<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $pageTitle }} — {{ $appName }}</title>
    <link rel="icon" href="{{ asset('assets/id-shaydi-logo.png') }}">
    <link rel="stylesheet" href="{{ asset('css/admin.css') }}">
</head>
<body>
<div class="admin-shell">
    @include('admin.partials.sidebar')

    <div class="main">
        <header class="topbar">
            <div>
                <h2>{{ $pageTitle }}</h2>
                <span>Welcome, {{ $adminUsername ?? 'admin' }}</span>
            </div>
            <div class="topbar-actions">
                <span>{{ now()->format('d M Y') }}</span>
                <form method="POST" action="{{ route('admin.logout') }}" class="logout-form">
                    @csrf
                    <button type="submit" class="btn-logout">Logout</button>
                </form>
            </div>
        </header>

        <div class="content">
            @yield('content')
        </div>
    </div>
</div>
</body>
</html>
